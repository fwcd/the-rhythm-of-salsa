struct Pattern: Hashable {
    var name: String = "Default"
    var length: Beats? = nil
    var volume: Double = 1
    var tracksKey: Bool = false
    var offsetEvents: [OffsetEvent] = []
}
