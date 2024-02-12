import AVFoundation

extension AVMIDINoteEvent {
    convenience init(_ event: Event) {
        self.init(
            channel: event.channel,
            key: event.key,
            velocity: event.velocity,
            duration: AVMusicTimeStamp(event.duration.rawValue)
        )
    }
}

extension Event {
    init(_ avEvent: AVMIDINoteEvent) {
        self.init(
            channel: avEvent.channel,
            key: avEvent.key,
            velocity: avEvent.velocity,
            duration: Beats(avEvent.duration)
        )
    }
}
