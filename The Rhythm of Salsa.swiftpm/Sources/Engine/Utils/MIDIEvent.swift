import AVFoundation

enum MIDIEvent {
    case meta(MIDIMetaEvent)
    case note(MIDINoteMessage)
    case channel(MIDIChannelMessage)
}

extension MIDIMetaEvent {
    init?(_ event: MIDIEvent) {
        guard case let .meta(meta) = event else { return nil }
        self = meta
    }
}

extension MIDINoteMessage {
    init?(_ event: MIDIEvent) {
        guard case let .note(message) = event else { return nil }
        self = message
    }
}

extension MIDIChannelMessage {
    init?(_ event: MIDIEvent) {
        guard case let .channel(message) = event else { return nil }
        self = message
    }
}
