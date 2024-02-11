import Foundation

/// A sequencer track holding note events for a certain instrument.
struct Track: Hashable, Codable, Identifiable {
    var id = UUID()
    var instrument: Instrument = .clave
    var length: Beats = 8
    var isLooping: Bool = true
    var offsetEvents: [OffsetEvent] = []
    
    var shortDescription: String {
        "\(id) (\(instrument), \(length))"
    }
    
    func findEvents(in range: Range<Beats>) -> [OffsetEvent] {
        offsetEvents.filter { event in
            range.overlaps(event.range)
        }
    }
    
    mutating func removeEvents(in range: Range<Beats>) {
        offsetEvents.removeAll { event in
            range.overlaps(event.range)
        }
    }
    
    mutating func replaceEvents(in range: Range<Beats>, with event: Event) {
        removeEvents(in: range)
        offsetEvents.append(.init(event: event, startOffset: range.lowerBound))
    }
}
