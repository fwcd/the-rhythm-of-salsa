import Foundation

extension Track {
    init(
        id: String = UUID().uuidString,
        preset: TrackPreset = .init(),
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
            pattern: instrument.patterns.first ?? .init()
        )
    }
}
