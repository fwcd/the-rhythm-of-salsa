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
