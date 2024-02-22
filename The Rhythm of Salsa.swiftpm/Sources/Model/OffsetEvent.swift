import Foundation

struct OffsetEvent: Hashable, Codable {
    var event: Event
    var startOffset: Beats
    
    var duration: Beats {
        event.duration
    }
    
    var endOffset: Beats {
        startOffset + duration
    }
    
    var range: Range<Beats> {
        startOffset..<endOffset
    }
}