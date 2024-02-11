struct OffsetEvent: Hashable, Codable {
    let event: Event
    let offset: Beats
}
