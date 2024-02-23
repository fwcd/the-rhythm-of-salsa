import AVFoundation
import Combine
import OSLog

private let log = Logger(subsystem: AppConstants.name, category: "Engine.BeatSequencerEngine")

private func configureAVAudioSession() {
    let session = AVAudioSession.sharedInstance()
    do {
        try session.setCategory(.playback)
    } catch {
        log.error("Could not set audio session category: \(error)")
    }
    do {
        try session.setActive(true)
    } catch {
        log.error("Could not activate audio session: \(error)")
    }
}

class BeatSequencerEngine: ObservableObject {
    private let samplers: [Instrument: AVAudioUnitSampler]
    
    private var engine: AVAudioEngine
    private var sequencer: AVAudioSequencer
    private var sequencerPlaybackDependents: Int = 0 {
        didSet {
            updateSequencerPlayState()
        }
    }
    
    @Published var model: BeatSequencerModel = .init()
    @Published var userModel: BeatSequencerModel = .init(
        tracks: Instrument.allCases.compactMap { instrument in
            Track(instrument: instrument)
        }
    )
    @Published private(set) var playhead: Beats = 0
    
    @Published var shouldSyncUserModel: Bool = false
    private var doesSyncUserModel: Bool = false
    
    private var activeModel: BeatSequencerModel? = nil
    private var sequencerTracks: [TrackPreset: AVMusicTrack] = [:]
    
    private var cancellables: Set<AnyCancellable> = []
    
    // Credits go to
    // - https://www.rockhoppertech.com/blog/swift-2-avaudiosequencer/
    // - https://www.rockhoppertech.com/blog/the-great-avaudiounitsampler-workout/
    
    init() {
        configureAVAudioSession()
        
        let engine = AVAudioEngine()
        sequencer = AVAudioSequencer(audioEngine: engine)
        
        var samplers: [Instrument: AVAudioUnitSampler] = [:]
        
        for instrument in Instrument.allCases {
            let sampler = AVAudioUnitSampler()
            samplers[instrument] = sampler
            
            DispatchQueue.global().async {
                engine.attach(sampler)
                engine.connect(sampler, to: engine.mainMixerNode, format: nil)
            }
            
            if !instrument.sampleNames.isEmpty {
                do {
                    // TODO: Loading all samples per instrument would play them simultaneously. It would be nice if we could e.g. map them to different keys. That might require using CAF files instead of WAV, which e.g. would let us set the base note and a range of low-high notes. See https://developer.apple.com/library/archive/documentation/MusicAudio/Reference/CAFSpec/CAF_spec/CAF_spec.html for details.
                    try sampler.loadAudioFiles(at: Array(instrument.sampleURLs.prefix(1)))
                } catch {
                    log.error("Could not load audio file(s) for \(instrument) sampler: \(error)")
                }
            } else {
                log.warning("Sampler for \(instrument) has no audio files!")
            }
        }
        
        self.engine = engine
        self.samplers = samplers
        
        do {
            try engine.start()
        } catch {
            log.error("Could not start audio engine: \(error)")
        }
        
        // Set up model-sequencer synchronization
        $model
            .sink { newModel in
                self.syncSequencer(with: newModel)
                self.updateSequencerPlayState()
            }
            .store(in: &cancellables)
        syncSequencer(with: model)
        
        $shouldSyncUserModel
            .sink { shouldSyncUserModel in
                guard shouldSyncUserModel != self.doesSyncUserModel else { return }
                if shouldSyncUserModel {
                    self.model = self.userModel
                } else {
                    self.userModel = self.model
                }
                self.doesSyncUserModel = shouldSyncUserModel
            }
            .store(in: &cancellables)
        
        // Repeatedly poll the actual playhead position
        // TODO: Make the polling frequency dependent on the BPM
        Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                let newPlayhead = Beats(sequencer.currentPositionInBeats)
                if newPlayhead != playhead {
                    playhead = newPlayhead
                }
            }
            .store(in: &cancellables)
    }
    
    private func syncSequencer(with newModel: BeatSequencerModel) {
        syncSequencerTracks(with: newModel.tracks)
        
        if activeModel?.mainVolume != newModel.mainVolume {
            engine.mainMixerNode.outputVolume = Float(newModel.mainVolume)
        }
        
        if activeModel?.beatsPerMinute != newModel.beatsPerMinute {
            let tempoTrack = sequencer.tempoTrack
            if activeModel != nil {
                tempoTrack.clearEvents(in: AVMakeBeatRange(0, AVMusicTimeStampEndOfTrack))
            }
            tempoTrack.addEvent(AVExtendedTempoEvent(tempo: newModel.beatsPerMinute.rawValue), at: 0)
        }
       
        activeModel = newModel
    }
    
    private func syncSequencerTracks(with newTracks: [Track]) {
        let activeTracks = activeModel?.tracks ?? []
        let activeTracksByPreset = Dictionary(grouping: activeTracks, by: \.preset)
        let newTracksByPreset = Dictionary(grouping: newTracks, by: \.preset)
        
        // Create sequencer tracks for missing presets
        
        let newPresets = Set(newTracksByPreset.keys)
        let missingPresets = newPresets.subtracting(sequencerTracks.keys)
        
        let wasPlaying = sequencer.isPlaying
        let changedEvents = activeTracks.flatMap(\.offsetEvents) != newTracks.flatMap(\.offsetEvents)
        let shouldStartStop = wasPlaying && changedEvents
        
        if shouldStartStop {
            stopSequencer()
        }
        
        for preset in missingPresets {
            let sequencerTrack = sequencer.createAndAppendTrack()
            sequencerTrack.destinationAudioUnit = preset.instrument.flatMap { samplers[$0] }
            sequencerTrack.lengthInBeats = AVMusicTimeStamp(preset.length.rawValue)
            sequencerTrack.isLoopingEnabled = preset.isLooping
            sequencerTracks[preset] = sequencerTrack
        }
        
        // Sync each sequencer track, keyed by preset
        for (preset, sequencerTrack) in sequencerTracks {
            let activeTracksForPreset = activeTracksByPreset[preset] ?? []
            let newTracksForPreset = newTracksByPreset[preset] ?? []
            sync(
                sequencerTrack: sequencerTrack,
                activeTracks: activeTracksForPreset,
                with: newTracksForPreset
            )
        }
        
        // Jump to the first loop to not skip a beat
        if changedEvents {
            jumpToFirstLoop(using: newTracks)
        }
        
        if shouldStartStop {
            startSequencer()
        }
    }
    
    private func sync(sequencerTrack: AVMusicTrack, activeTracks: [Track], with newTracks: [Track]) {
        guard activeTracks != newTracks else { return }
        
        // If a single sequencer track only maps to one model track, we can set the volume directly on the sampler unit as an optimization (instead of having to change the velocities of individual events)
        var optimized = false
        if newTracks.count == 1,
           let newTrack = newTracks.first,
           let sampler = sequencerTrack.destinationAudioUnit as? AVAudioUnitSampler {
            sampler.volume = Float(newTrack.volume)
            sequencerTrack.isMuted = newTrack.isMute
            sequencerTrack.isSoloed = newTrack.isSolo
            optimized = true
        }
        
        guard !optimized || activeTracks.map(\.offsetEvents) != newTracks.map(\.offsetEvents) else { return }
        
        if !activeTracks.flatMap(\.offsetEvents).isEmpty {
            // TODO: Check whether this is the right range
            sequencerTrack.clearEvents(in: AVMakeBeatRange(0, AVMusicTimeStampEndOfTrack))
        }
        
        for newTrack in newTracks {
            for offsetEvent in newTrack.offsetEvents {
                var event = offsetEvent.event
                if !optimized {
                    var volume = newTrack.volume
                    // NOTE: Solo is currently only supported in the single-track ("optimized") case since it would require changing other tracks' events too in the non-optimized case
                    if newTrack.isMute {
                        volume = 0
                    }
                    event.velocity = UInt32(min(max(Double(event.velocity) * volume, 0), 127))
                }
                sequencerTrack.addEvent(
                    AVMIDINoteEvent(event),
                    at: AVMusicTimeStamp(offsetEvent.startOffset.rawValue)
                )
            }
        }
    }
    
    func incrementPlaybackDependents() {
        sequencerPlaybackDependents += 1
    }
    
    func decrementPlaybackDependents() {
        sequencerPlaybackDependents -= 1
    }
    
    func jumpToFirstLoop(using tracks: [Track]? = nil) {
        let loopLength = (tracks ?? model.tracks)
            .filter { !$0.isSilent }
            .map { Int($0.length.rawValue.rounded()) }
            .reduce(1) { $0.leastCommonMultiple($1) }
        sequencer.currentPositionInBeats = sequencer.currentPositionInBeats
            .truncatingRemainder(dividingBy: Double(loopLength))
    }
    
    func movePlayhead(to beats: Beats) {
        sequencer.currentPositionInBeats = TimeInterval(beats.rawValue)
    }
    
    private func updateSequencerPlayState() {
        if sequencerPlaybackDependents > 0 && !(activeModel?.tracks.isEmpty ?? true) {
            startSequencer()
        } else {
            stopSequencer()
        }
    }
    
    private func startSequencer() {
        guard !sequencer.isPlaying else { return }
        do {
            sequencer.prepareToPlay()
            try sequencer.start()
        } catch {
            log.error("Could not start the sequencer: \(error)")
        }
    }
    
    private func stopSequencer() {
        guard sequencer.isPlaying else { return }
        sequencer.stop()
    }
}
