/// A sequencer track holding note events for a certain instrument.
struct Track: Hashable, Codable {
    var instrument: Instrument = .clave
    var offsetEvents: [OffsetEvent] = []
    
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
}
