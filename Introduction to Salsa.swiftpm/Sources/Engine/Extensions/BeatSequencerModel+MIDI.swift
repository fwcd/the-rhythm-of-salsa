import Foundation
import OSLog
import AVFoundation

fileprivate let log = Logger(subsystem: "Introduction to Salsa", category: "Engine.BeatSequencerModel+MIDI")

extension BeatSequencerModel {
    init(midiFileURL: URL) throws {
        var sequence: MusicSequence?
        guard NewMusicSequence(&sequence) == OSStatus(noErr), let sequence else {
            throw MusicSequenceError.couldNotCreate
        }
        
        defer {
            if DisposeMusicSequence(sequence) != OSStatus(noErr) {
                log.error("Could not dispose of MusicSequence in \(#function)")
            }
        }
        
        guard MusicSequenceFileLoad(sequence, midiFileURL as CFURL, .midiType, []) == OSStatus(noErr) else {
            throw MusicSequenceError.couldNotLoadMIDIFile(midiFileURL)
        }
        
        self = try Self(sequence)
    }
}

