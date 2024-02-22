import AVFoundation

extension Event {
    init(_ event: MIDINoteMessage) {
        self.init(
            channel: UInt32(event.channel),
            key: UInt32(event.note),
            velocity: UInt32(event.velocity),
            duration: Beats(Double(event.duration))
        )
    }
}

extension MIDINoteMessage {
    init(_ event: Event) {
        self.init(
            channel: UInt8(event.channel),
            note: UInt8(event.key),
            velocity: UInt8(event.velocity),
            releaseVelocity: UInt8(event.velocity),
            duration: Float32(Double(event.duration))
        )
    }
}
