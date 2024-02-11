import Foundation

struct OffsetEvent: Hashable, Codable, Identifiable {
    var id = UUID()
    var event: Event
    var startOffset: Beats
    
    var endOffset: Beats {
        startOffset + event.duration
    }
    
    var range: Range<Beats> {
        startOffset..<endOffset
    }
}
