struct Pattern: Hashable {
    var name: String = "Default"
    var length: Beats? = nil
    var offsetEvents: [OffsetEvent] = []
}
