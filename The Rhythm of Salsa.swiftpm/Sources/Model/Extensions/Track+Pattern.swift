import Foundation

extension Track {
    init(
        id: String = UUID().uuidString,
        preset: TrackPreset = .init(),
        tracksKey: Bool = false,
        pattern: Pattern
    ) {
        var preset = preset
        if let length = pattern.length {
            preset.length = length
        }
        self.init(
            id: id,
            preset: preset,
            patternName: pattern.name,
            volume: pattern.volume,
            tracksKey: tracksKey,
            offsetEvents: pattern.offsetEvents
        )
    }
    
    init(
        id: String = UUID().uuidString,
        instrument: Instrument
    ) {
        self.init(
            id: id,
            preset: .init(instrument: instrument),
            tracksKey: instrument.tracksKey,
            pattern: instrument.patterns.first ?? .init()
        )
    }
}
