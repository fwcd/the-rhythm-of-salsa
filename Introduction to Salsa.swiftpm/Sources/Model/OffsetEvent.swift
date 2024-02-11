struct OffsetEvent: Hashable, Codable {
    let event: Event
    let startOffset: Beats
    
    var endOffset: Beats {
        startOffset + event.duration
    }
    
    var range: Range<Beats> {
        startOffset..<endOffset
    }
}
