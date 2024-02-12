/// A MIDI-style note event.
struct Event: Codable, Hashable {
    /// The MIDI channel.
    var channel: UInt32 = 0
    /// The MIDI key.
    var key: UInt32 = 60
    /// The MIDI velocity.
    var velocity: UInt32 = 127
    /// The duration of the event in beats.
    var duration: Beats = 1
}
