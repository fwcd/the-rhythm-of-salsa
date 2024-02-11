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
