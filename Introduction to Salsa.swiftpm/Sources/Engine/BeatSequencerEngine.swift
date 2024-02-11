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
            
            do {
                // TODO: Currently all samples per instrument seem to play simultaneously. It would be nice if we could e.g. map them to different keys. That might require using CAF files instead of WAV, which e.g. would let us set the base note and a range of low-high notes. See https://developer.apple.com/library/archive/documentation/MusicAudio/Reference/CAFSpec/CAF_spec/CAF_spec.html for details.
                try sampler.loadAudioFiles(at: instrument.sampleURLs)
            } catch {
                log.error("Could not load sampler audio files: \(error)")
            }
        }
        
        self.samplers = samplers
        
        do {
            try engine.start()
        } catch {
            log.error("Could not start audio engine: \(error)")
        }
        
        sequencer = AVAudioSequencer(audioEngine: engine)
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
    
    func playDebugSample() {
        samplers[.bongos]!.startNote(60, withVelocity: 128, onChannel: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.samplers[.bongos]!.stopNote(0, onChannel: 0)
        }
    }
}
