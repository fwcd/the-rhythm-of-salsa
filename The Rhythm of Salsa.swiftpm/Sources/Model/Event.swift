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
    
    func transposed(by semitones: Int) -> Event {
        var event = self
        event.transpose(by: semitones)
        return event
    }
    
    mutating func transpose(by semitones: Int) {
        key = UInt32(min(max(Int(key) + semitones, 0), 127))
    }
}
