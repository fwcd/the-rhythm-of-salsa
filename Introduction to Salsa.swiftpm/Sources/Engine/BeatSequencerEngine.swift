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
    
    private let sequencer: AVAudioSequencer
    private let sequencerPlaybackRequestorQueue = DispatchQueue(label: "Engine.BeatSequencerEngine.sequencerPlaybackRequestorQueue")
    private var sequencerPlaybackRequestors: Int = 0 {
        didSet {
            if sequencerPlaybackRequestors > 0 {
                do {
                    try sequencer.start()
                } catch {
                    log.error("Could not start the sequencer: \(error)")
                }
            } else {
                sequencer.stop()
            }
        }
    }
    
    @Published var tracks: [Track] = []
    private var activeTracks: [Track] = []
    private var sequencerTracks: [UUID: AVMusicTrack] = [:]
    
    private var cancellables: Set<AnyCancellable> = []
    
    // Credits go to
    // - https://www.rockhoppertech.com/blog/swift-2-avaudiosequencer/
    // - https://www.rockhoppertech.com/blog/the-great-avaudiounitsampler-workout/
    
    init() {
        configureAVAudioSession()
        
        engine = AVAudioEngine()
        
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
        
        sequencer = AVAudioSequencer(audioEngine: engine)
        sequencer.prepareToPlay()
        
        do {
            try engine.start()
        } catch {
            log.error("Could not start audio engine: \(error)")
        }
        
        $tracks
            .sink { tracks in
                self.syncSequencer(with: tracks)
            }
            .store(in: &cancellables)
        
        // TODO: Set up the tracks dynamically
        tracks = Instrument.allCases.map { Track(instrument: $0) }
    }
    
    private func syncSequencer(with newTracks: [Track]) {
        let newById = Dictionary(grouping: newTracks, by: \.id).mapValues { $0[0] }
        let activeById = Dictionary(grouping: activeTracks, by: \.id).mapValues { $0[0] }
        
        let newIds = Set(newById.keys)
        let activeIds = Set(activeById.keys)
        
        let removedIds = activeIds.subtracting(newIds)
        let addedIds = newIds.subtracting(activeIds)
        
        for id in removedIds {
            let track = activeById[id]!
            if let sequencerTrack = sequencerTracks[id] {
                sequencer.removeTrack(sequencerTrack)
                sequencerTracks[id] = nil
                log.debug("Removed track \(track.shortDescription) from sequencer")
            } else {
                log.warning("Ignoring that the sequencer does not have the to-be-removed track \(String(describing: track)) (this shouldn't happen and probably indicates a bug).")
            }
        }
        
        for id in addedIds {
            let track = newById[id]!
            let sequencerTrack = sequencer.createAndAppendTrack()
            sequencerTracks[id] = sequencerTrack
            log.debug("Added track \(track.shortDescription) to sequencer")
        }
        
        activeTracks = newTracks
    }
    
    /// Guarantees playback while the returned object is held.
    func requestPlayback() -> Guard {
        sequencerPlaybackRequestorQueue.sync {
            sequencerPlaybackRequestors += 1
        }
        return Guard {
            self.sequencerPlaybackRequestorQueue.async {
                self.sequencerPlaybackRequestors -= 1
            }
        }
    }
}
