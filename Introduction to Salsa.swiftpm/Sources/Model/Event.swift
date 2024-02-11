/// A MIDI-style note event.
struct Event: Codable, Hashable {
    /// The MIDI channel.
    var channel: UInt8 = 0
    /// The MIDI key.
    var note: UInt8 = 60
    /// The MIDI velocity.
    var velocity: UInt8 = 128
    /// The duration of the event in beats.
    var duration: Beats = 1
}
