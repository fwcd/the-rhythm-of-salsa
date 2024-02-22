/// A sequence of note events with a volume, key, length and a name.
struct Pattern: Hashable {
    var name: String = "Default"
    var length: Beats? = nil
    var volume: Double = 1
    var key: Key = .c
    var offsetEvents: [OffsetEvent] = []
}
