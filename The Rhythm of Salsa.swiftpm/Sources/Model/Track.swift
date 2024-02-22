import Foundation

/// A sequencer track containing note events played by an instrument.
struct Track: Hashable, Codable, Identifiable {
    var id: String = UUID().uuidString
    var preset: TrackPreset = .init()
    var patternName: String? = nil
    var volume: Double = 1
    var isMute: Bool = false
    var isSolo: Bool = false
    var offsetEvents: [OffsetEvent] = []
    
    var isSilent: Bool {
        isMute || offsetEvents.isEmpty || volume == 0
    }
    
    var tracksKey: Bool {
        preset.instrument?.tracksKey ?? false
    }
    
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
    
    func transposed(by semitones: Int) -> Track {
        var track = self
        track.transpose(by: semitones)
        return track
    }
    
    mutating func transpose(by semitones: Int) {
        offsetEvents = offsetEvents.map {
            $0.mapEvent {
                $0.transposed(by: semitones)
            }
        }
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
