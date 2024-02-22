import AVFoundation

enum MIDIEvent {
    case meta(type: MIDIMetaEventType, raw: Data)
    case note(MIDINoteMessage)
    case channel(MIDIChannelMessage)
    
    var asMetaEvent: (type: MIDIMetaEventType, raw: Data)? {
        guard case let .meta(type, raw) = self else { return nil }
        return (type: type, raw: raw)
    }
    
    var asNoteMessage: MIDINoteMessage? {
        guard case let .note(message) = self else { return nil }
        return message
    }
    
    var asChannelMessage: MIDIChannelMessage? {
        guard case let .channel(message) = self else { return nil }
        return message
    }
}

extension MIDINoteMessage {
    init?(_ event: MIDIEvent) {
        guard let message = event.asNoteMessage else { return nil }
        self = message
    }
}

extension MIDIChannelMessage {
    init?(_ event: MIDIEvent) {
        guard let message = event.asChannelMessage else { return nil }
        self = message
    }
}
