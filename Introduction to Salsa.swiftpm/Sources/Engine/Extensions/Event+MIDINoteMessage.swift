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
