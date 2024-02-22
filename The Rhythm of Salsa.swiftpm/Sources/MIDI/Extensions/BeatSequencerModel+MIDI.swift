import Foundation
import OSLog
import AVFoundation

private let log = Logger(subsystem: AppConstants.name, category: "Engine.BeatSequencerModel+MIDI")

extension BeatSequencerModel {
    init(midiFileURL: URL) throws {
        @Guard var sequence: MusicSequence
        _sequence = try makeMusicSequence()
        
        guard MusicSequenceFileLoad(sequence, midiFileURL as CFURL, .midiType, []) == OSStatus(noErr) else {
            throw MusicSequenceError.couldNotLoadMIDIFile(midiFileURL)
        }
        
        self = try Self(sequence)
    }
    
    func writeTo(midiFileURL: URL) throws {
        @Guard var sequence: MusicSequence
        _sequence = try makeMusicSequence()
        
        try writeTo(sequence)
        
        guard MusicSequenceFileCreate(sequence, midiFileURL as CFURL, .midiType, .eraseFile, 0) == OSStatus(noErr) else {
            throw MusicSequenceError.couldNotCreateMIDIFile(midiFileURL)
        }
    }
    
    func midiData() throws -> Data {
        @Guard var sequence: MusicSequence
        _sequence = try makeMusicSequence()
        
        try writeTo(sequence)
        
        var data: Unmanaged<CFData>?
        guard MusicSequenceFileCreateData(sequence, .midiType, .eraseFile, 0, &data) == OSStatus(noErr), let data = data?.takeUnretainedValue() else {
            throw MusicSequenceError.couldNotCreateMIDIData
        }
        
        return data as Data
    }
}

private func makeMusicSequence(function: String = #function) throws -> Guard<MusicSequence> {
    var sequence: MusicSequence?
    guard NewMusicSequence(&sequence) == OSStatus(noErr), let sequence else {
        throw MusicSequenceError.couldNotCreate
    }
    
    return Guard(wrappedValue: sequence) {
        if DisposeMusicSequence(sequence) != OSStatus(noErr) {
            log.error("Could not dispose of MusicSequence in \(function)")
        }
    }
}
