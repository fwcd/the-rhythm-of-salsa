import Foundation
import AVFoundation

extension BeatSequencerModel {
    init(midiFileURL: URL) throws {
        var sequence: MusicSequence?
        guard NewMusicSequence(&sequence) == OSStatus(noErr), let sequence else {
            throw MusicSequenceError.couldNotCreate
        }
        
        guard MusicSequenceFileLoad(sequence, midiFileURL as CFURL, .midiType, []) == OSStatus(noErr) else {
            throw MusicSequenceError.couldNotLoadMIDIFile(midiFileURL)
        }
        
        let model = try Self(sequence)
        
        guard DisposeMusicSequence(sequence) == OSStatus(noErr) else {
            throw MusicSequenceError.couldNotDisposeOf
        }
        
        self = model
    }
    
    // TODO: Writing
}
