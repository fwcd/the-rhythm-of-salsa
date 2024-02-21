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
        
        // TODO: Mute/solo
        
        let timestampEvents = try track.midiTimestampEvents
        let channel = timestampEvents.compactMap { MIDINoteMessage($0.event)?.channel }.first
        let offsetEvents = timestampEvents.compactMap { timestampEvent in
            MIDINoteMessage(timestampEvent.event).map {
                OffsetEvent(
                    event: Event($0),
                    startOffset: Beats(timestampEvent.timestamp)
                )
            }
        }
        
        self.init(
            preset: .init(
                instrument: channel.flatMap { Instrument(ordinal: Int($0)) } ?? .piano,
                length: Beats(length),
                isLooping: loopInfo.numberOfLoops > 1
            ),
            offsetEvents: offsetEvents
        )
    }
    
    func writeTo(_ track: MusicTrack) throws {
        var loopInfo = MusicTrackLoopInfo(loopDuration: MusicTimeStamp(preset.length), numberOfLoops: .max)
        guard (try? track.setProperty(kSequenceTrackProperty_LoopInfo, to: &loopInfo)) != nil else {
            throw MusicTrackError.couldNotSetLoopInfo
        }
        
        var length = MusicTimeStamp(preset.length)
        guard (try? track.setProperty(kSequenceTrackProperty_TrackLength, to: &length)) != nil else {
            throw MusicTrackError.couldNotSetLength
        }
        
        // TODO: Mute/solo
        
        for event in offsetEvents {
            let timestamp = MusicTimeStamp(event.startOffset)
            var message = MIDINoteMessage(event.event)
            if let ordinal = instrument?.ordinal {
                message.channel = UInt8(ordinal)
            }
            guard MusicTrackNewMIDINoteEvent(track, timestamp, &message) == OSStatus(noErr) else {
                throw MusicTrackError.couldNotCreateMIDIEvent(event)
            }
        }
    }
}

