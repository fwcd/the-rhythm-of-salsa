import Foundation
import OSLog
import AVFoundation

private let log = Logger(subsystem: "Introduction to Salsa", category: "Engine.BeatSequencerModel+MIDI")

extension BeatSequencerModel {
    init(midiFileURL: URL) throws {
        try withNewMusicSequence { sequence in
            guard MusicSequenceFileLoad(sequence, midiFileURL as CFURL, .midiType, []) == OSStatus(noErr) else {
                throw MusicSequenceError.couldNotLoadMIDIFile(midiFileURL)
            }
            
            self = try Self(sequence)
        }
    }
    
    func writeTo(midiFileURL: URL) throws {
        try withNewMusicSequence { sequence in
            try writeTo(sequence)
            
            guard MusicSequenceFileCreate(sequence, midiFileURL as CFURL, .midiType, .eraseFile, 0) == OSStatus(noErr) else {
                throw MusicSequenceError.couldNotCreateMIDIFile(midiFileURL)
            }
        }
    }
    
    func midiData() throws -> Data {
        try withNewMusicSequence { sequence in
            try writeTo(sequence)
            
            var data: Unmanaged<CFData>?
            guard MusicSequenceFileCreateData(sequence, .midiType, .eraseFile, 0, &data) == OSStatus(noErr), let data = data?.takeUnretainedValue() else {
                throw MusicSequenceError.couldNotCreateMIDIData
            }
            
            return data as Data
        }
    }
}

private func withNewMusicSequence<T>(
    function: String = #function,
    _ action: (MusicSequence) throws -> T
) throws -> T {
    var sequence: MusicSequence?
    guard NewMusicSequence(&sequence) == OSStatus(noErr), let sequence else {
        throw MusicSequenceError.couldNotCreate
    }
    
    defer {
        if DisposeMusicSequence(sequence) != OSStatus(noErr) {
            log.error("Could not dispose of MusicSequence in \(function)")
        }
    }
    
    return try action(sequence)
}
