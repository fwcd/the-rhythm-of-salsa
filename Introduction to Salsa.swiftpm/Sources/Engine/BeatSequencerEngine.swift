import AVFoundation
import Combine
import OSLog

private let log = Logger(subsystem: "Introduction to Salsa", category: "Engine.BeatSequencerEngine")

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
    private let engine: AVAudioEngine
    private let samplers: [Instrument: AVAudioUnitSampler]
    
    private var sequencer: AVAudioSequencer
    private var sequencerPlaybackDependents: Int = 0 {
        didSet {
            updateSequencerPlayState()
        }
    }
    
    @Published var model: BeatSequencerModel = .init()
    @Published var playhead: Beats = 0
    private var activeModel: BeatSequencerModel? = nil
    private var sequencerTracks: [TrackPreset: AVMusicTrack] = [:]
    
    private var cancellables: Set<AnyCancellable> = []
    
    // Credits go to
    // - https://www.rockhoppertech.com/blog/swift-2-avaudiosequencer/
    // - https://www.rockhoppertech.com/blog/the-great-avaudiounitsampler-workout/
    
    init() {
        configureAVAudioSession()
        
        engine = AVAudioEngine()
        sequencer = AVAudioSequencer(audioEngine: engine)
        
        var samplers: [Instrument: AVAudioUnitSampler] = [:]
        
        for instrument in Instrument.allCases {
            let sampler = AVAudioUnitSampler()
            samplers[instrument] = sampler
            
            engine.attach(sampler)
            engine.connect(sampler, to: engine.mainMixerNode, format: nil)
            
            if !instrument.sampleNames.isEmpty {
                do {
                    // TODO: Currently all samples per instrument seem to play simultaneously. It would be nice if we could e.g. map them to different keys. That might require using CAF files instead of WAV, which e.g. would let us set the base note and a range of low-high notes. See https://developer.apple.com/library/archive/documentation/MusicAudio/Reference/CAFSpec/CAF_spec/CAF_spec.html for details.
                    try sampler.loadAudioFiles(at: instrument.sampleURLs)
                } catch {
                    log.error("Could not load audio file(s) for \(instrument) sampler: \(error)")
                }
            } else {
                log.warning("Sampler for \(instrument) has no audio files!")
            }
        }
        
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
        
        if activeModel?.beatsPerMinute != newModel.beatsPerMinute {
            let tempoTrack = sequencer.tempoTrack
            if activeModel != nil {
                tempoTrack.clearEvents(in: AVMakeBeatRange(0, AVMusicTimeStampEndOfTrack))
            }
            tempoTrack.addEvent(AVExtendedTempoEvent(tempo: newModel.beatsPerMinute), at: 0)
        }
       
        activeModel = newModel
    }
    
    private func syncSequencerTracks(with newTracks: [Track]) {
        let activeTracksByPreset = Dictionary(grouping: activeModel?.tracks ?? [], by: \.preset)
        let newTracksByPreset = Dictionary(grouping: newTracks, by: \.preset)
        
        // Create sequencer tracks for missing presets
        
        let newPresets = Set(newTracksByPreset.keys)
        let missingPresets = newPresets.subtracting(sequencerTracks.keys)
        
        let wasPlaying = sequencer.isPlaying
        if wasPlaying {
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
            let activeTracks = activeTracksByPreset[preset] ?? []
            let newTracks = newTracksByPreset[preset] ?? []
            sync(sequencerTrack: sequencerTrack, activeTracks: activeTracks, with: newTracks)
        }
        
        if wasPlaying {
            startSequencer()
        }
    }
    
    private func sync(sequencerTrack: AVMusicTrack, activeTracks: [Track], with newTracks: [Track]) {
        guard activeTracks != newTracks else { return }
        
        if !activeTracks.flatMap(\.offsetEvents).isEmpty {
            // TODO: Check whether this is the right range
            sequencerTrack.clearEvents(in: AVMakeBeatRange(0, AVMusicTimeStampEndOfTrack))
        }
        
        for newTrack in newTracks {
            for offsetEvent in newTrack.offsetEvents {
                sequencerTrack.addEvent(
                    AVMIDINoteEvent(offsetEvent.event),
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
