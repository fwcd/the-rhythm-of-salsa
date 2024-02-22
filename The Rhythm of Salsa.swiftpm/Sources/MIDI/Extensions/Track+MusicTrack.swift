import AVFoundation

extension Track {
    init?(_ track: MusicTrack, ignoreIfNonInstrumental: Bool = true) throws {
        var length: MusicTimeStamp = 0
        guard (try? track.getProperty(kSequenceTrackProperty_TrackLength, into: &length)) != nil else {
            throw MusicTrackError.couldNotGetLength
        }
        
        let timestampEvents = try track.midiTimestampEvents
        let metaEvents = timestampEvents.compactMap(\.event.asMetaEvent)
        
        let instrument = metaEvents
            .first { $0.pointee.type == .instrumentName }
            .flatMap { $0.pointee.text.map { Instrument(rawValue: $0) } }
        
        let trackInfo = metaEvents
            .first { $0.pointee.type == .sequencerSpecific }
            .flatMap { try? $0.pointee.decoded(as: MetaEventTrackInfo.self) }
        
        let channel = timestampEvents.compactMap { MIDINoteMessage($0.event)?.channel }.first
        let offsetEvents = timestampEvents.compactMap { timestampEvent in
            MIDINoteMessage(timestampEvent.event).map {
                OffsetEvent(
                    event: Event($0),
                    startOffset: Beats(timestampEvent.timestamp)
                )
            }
        }
        
        if ignoreIfNonInstrumental {
            guard instrument != nil || !offsetEvents.isEmpty else { return nil }
        }
        
        self.init(
            preset: .init(
                instrument: instrument ?? channel.flatMap { Instrument(ordinal: Int($0)) } ?? .piano,
                length: Beats(length),
                isLooping: trackInfo?.isLooping ?? true
            ),
            isMute: trackInfo?.isMute ?? false,
            isSolo: trackInfo?.isSolo ?? false,
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
            
            @Guard var trackInfoEvent: UnsafeMutablePointer<MIDIMetaEvent>
            _trackInfoEvent = try MIDIMetaEvent.create(
                type: .sequencerSpecific,
                encoding: MetaEventTrackInfo(
                    isLooping: preset.isLooping,
                    isSolo: isSolo,
                    isMute: isMute
                )
            )
            guard MusicTrackNewMetaEvent(track, MusicTimeStamp(0), trackInfoEvent) == OSStatus(noErr) else {
                throw MusicTrackError.couldNotAddTrackInfoEvent
            }
        }
        
        var length = MusicTimeStamp(preset.length)
        guard (try? track.setProperty(kSequenceTrackProperty_TrackLength, to: &length)) != nil else {
            throw MusicTrackError.couldNotSetLength
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

