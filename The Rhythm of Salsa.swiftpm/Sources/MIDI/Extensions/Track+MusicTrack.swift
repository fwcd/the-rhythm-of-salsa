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
        
        var mute: DarwinBoolean = false
        guard (try? track.getProperty(kSequenceTrackProperty_MuteStatus, into: &mute)) != nil else {
            throw MusicTrackError.couldNotGetMute
        }
        
        var solo: DarwinBoolean = false
        guard (try? track.getProperty(kSequenceTrackProperty_SoloStatus, into: &solo)) != nil else {
            throw MusicTrackError.couldNotGetSolo
        }
        
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
            isMute: mute.boolValue,
            isSolo: solo.boolValue,
            offsetEvents: offsetEvents
        )
    }
    
    func writeTo(_ track: MusicTrack) throws {
        if let instrument {
            @Guard var trackNameEvent: UnsafeMutablePointer<MIDIMetaEvent>
            _trackNameEvent = MIDIMetaEvent.create(
                type: .trackName,
                text: instrument.name
            )
            guard MusicTrackNewMetaEvent(track, MusicTimeStamp(0), trackNameEvent) == OSStatus(noErr) else {
                throw MusicTrackError.couldNotAddTrackNameEvent
            }
            
            @Guard var instrumentNameEvent: UnsafeMutablePointer<MIDIMetaEvent>
            _instrumentNameEvent = MIDIMetaEvent.create(
                type: .instrumentName,
                text: instrument.name
            )
            guard MusicTrackNewMetaEvent(track, MusicTimeStamp(0), instrumentNameEvent) == OSStatus(noErr) else {
                throw MusicTrackError.couldNotAddInstrumentNameEvent
            }
        }
        
        var loopInfo = MusicTrackLoopInfo(loopDuration: MusicTimeStamp(preset.length), numberOfLoops: .max)
        guard (try? track.setProperty(kSequenceTrackProperty_LoopInfo, to: &loopInfo)) != nil else {
            throw MusicTrackError.couldNotSetLoopInfo
        }
        
        var length = MusicTimeStamp(preset.length)
        guard (try? track.setProperty(kSequenceTrackProperty_TrackLength, to: &length)) != nil else {
            throw MusicTrackError.couldNotSetLength
        }
        
        var mute = DarwinBoolean(isMute)
        guard (try? track.setProperty(kSequenceTrackProperty_MuteStatus, to: &mute)) != nil else {
            throw MusicTrackError.couldNotSetMute
        }
        
        var solo = DarwinBoolean(isSolo)
        guard (try? track.setProperty(kSequenceTrackProperty_SoloStatus, to: &solo)) != nil else {
            throw MusicTrackError.couldNotSetSolo
        }
        
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

