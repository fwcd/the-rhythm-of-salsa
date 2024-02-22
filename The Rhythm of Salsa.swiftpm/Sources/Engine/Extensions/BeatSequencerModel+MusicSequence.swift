import AVFoundation

extension BeatSequencerModel {
    init(_ sequence: MusicSequence) throws {
        var beatsPerMinute: MusicTimeStamp = 0
        guard MusicSequenceGetBeatsForSeconds(sequence, 60, &beatsPerMinute) == OSStatus(noErr) else {
            throw MusicSequenceError.couldNotGetBeatsPerMinute
        }
        
        var trackCount: UInt32 = 0
        guard MusicSequenceGetTrackCount(sequence, &trackCount) == OSStatus(noErr) else {
            throw MusicSequenceError.couldNotGetTrackCount
        }
        
        let tracks = try (UInt32(0)..<trackCount).map { i in
            var track: MusicTrack? = nil
            guard MusicSequenceGetIndTrack(sequence, i, &track) == OSStatus(noErr), let track else {
                throw MusicSequenceError.couldNotGetTrack(Int(i))
            }
            return try Track(track)
        }
        
        self.init(
            beatsPerMinute: Beats(beatsPerMinute),
            tracks: tracks
        )
    }
    
    func writeTo(_ sequence: MusicSequence) throws {
        var tempoTrack: MusicTrack?
        guard MusicSequenceGetTempoTrack(sequence, &tempoTrack) == OSStatus(noErr), let tempoTrack else {
            throw MusicSequenceError.couldNotGetTempoTrack
        }
        
        @Guard var keySignatureEvent: UnsafeMutablePointer<MIDIMetaEvent>
        _keySignatureEvent = MIDIMetaEvent.create(
            // As per https://www.mixagesoftware.com/en/midikit/help/HTML/meta_events.html
            metaEventType: 0x59,
            unused1: 0x02,
            unused2: UInt8(bitPattern: Int8(key.ordinal)),
            unused3: 0 // major key
        )
        guard MusicTrackNewMetaEvent(tempoTrack, MusicTimeStamp(0), keySignatureEvent) == OSStatus(noErr) else {
            throw MusicSequenceError.couldNotAddKeySignatureEvent
        }
        
        guard MusicTrackNewExtendedTempoEvent(tempoTrack, MusicTimeStamp(0), Float64(beatsPerMinute.rawValue)) == OSStatus(noErr) else {
            throw MusicSequenceError.couldNotAddTempoEvent
        }
        
        for track in tracks {
            var musicTrack: MusicTrack?
            guard MusicSequenceNewTrack(sequence, &musicTrack) == OSStatus(noErr), let musicTrack else {
                throw MusicSequenceError.couldNotAddNewTrack
            }
            
            try track.writeTo(musicTrack)
        }
    }
}
