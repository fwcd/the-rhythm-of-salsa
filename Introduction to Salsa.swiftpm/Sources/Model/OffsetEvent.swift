import Foundation

struct OffsetEvent: Hashable, Codable {
    var event: Event
    var startOffset: Beats
    
    var endOffset: Beats {
        startOffset + event.duration
    }
    
    var range: Range<Beats> {
        startOffset..<endOffset
    }
}
