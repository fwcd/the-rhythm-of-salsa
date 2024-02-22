import AVFoundation

enum MIDIEvent {
    case note(MIDINoteMessage)
    case channel(MIDIChannelMessage)
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
