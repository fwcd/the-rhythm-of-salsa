import Foundation

/// A sequencer track holding note events for a certain instrument.
struct Track: Hashable, Codable, Identifiable {
    var id: String = UUID().uuidString
    var preset: TrackPreset = .init()
    var patternName: String? = nil
    var volume: Double = 1
    var offsetEvents: [OffsetEvent] = []
    
    var instrument: Instrument? {
        get { preset.instrument }
        set { preset.instrument = newValue }
    }
    
    var length: Beats {
        get { preset.length }
        set { preset.length = newValue }
    }
    
    var isLooping: Bool {
        get { preset.isLooping }
        set { preset.isLooping = true }
    }
    
    var shortDescription: String {
        "\(id) \(preset.shortDescription)"
    }
    
    func findEvents(in range: Range<Beats>) -> [OffsetEvent] {
        offsetEvents.filter { event in
            range.overlaps(event.range)
        }
    }
    
    func looped(_ offset: Beats) -> Beats {
        isLooping
            ? offset.truncatingRemainder(dividingBy: length)
            : offset
    }
    
    mutating func removeEvents(in range: Range<Beats>) {
        offsetEvents.removeAll { offsetEvent in
            range.overlaps(offsetEvent.range)
        }
    }
    
    mutating func updateEvents(in range: Range<Beats>, with updater: (inout Event) throws -> Void) rethrows {
        offsetEvents = try offsetEvents.compactMap { offsetEvent -> OffsetEvent? in
            var offsetEvent = offsetEvent
            if range.overlaps(offsetEvent.range) {
                try updater(&offsetEvent.event)
            }
            return offsetEvent
        }
    }
    
    mutating func replaceEvents(in range: Range<Beats>, with event: Event) {
        removeEvents(in: range)
        offsetEvents.append(.init(event: event, startOffset: range.lowerBound))
    }
}
