import AVFoundation

extension Track {
    init(_ track: MusicTrack) throws {
        var loopInfo = MusicTrackLoopInfo(loopDuration: 0, numberOfLoops: 1)
        guard (try? track.getProperty(kSequenceTrackProperty_LoopInfo, into: &loopInfo)) != nil else {
            throw MusicTrackError.couldNotGetLoopInfo
        }
        
        var length: MusicTimeStamp = 0
        guard (try? track.getProperty(kSequenceTrackProperty_TrackLength, into: &length)) != nil else {
            throw MusicTrackError.couldNotGetLength
        }
        
        let offsetEvents = try track.noteEvents.map {
            OffsetEvent(
                event: Event($0.message),
                startOffset: Beats($0.timestamp)
            )
        }
        
        self.init(
            preset: .init(
                instrument: .piano, // TODO: Parse instrument or let caller specify it
                length: Beats(length),
                isLooping: loopInfo.numberOfLoops > 1
            ),
            offsetEvents: offsetEvents
        )
    }
}

