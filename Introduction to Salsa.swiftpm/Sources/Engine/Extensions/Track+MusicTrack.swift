import AVFoundation

extension Track {
    init(_ track: MusicTrack) throws {
        guard let loopInfo: MusicTrackLoopInfo = try? track.getProperty(kSequenceTrackProperty_LoopInfo) else {
            throw MusicTrackError.couldNotGetLoopInfo
        }
        
        guard let length: MusicTimeStamp = try? track.getProperty(kSequenceTrackProperty_TrackLength) else {
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

