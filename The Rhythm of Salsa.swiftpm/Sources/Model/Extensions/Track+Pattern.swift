import Foundation

extension Track {
    init(
        id: String = UUID().uuidString,
        preset: TrackPreset = .init(),
        pattern: Pattern,
        tracksKey: Bool,
        transposedTo key: Key? = nil
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
        if let key {
            transpose(by: pattern.key.semitones(to: key))
        }
    }
    
    init(
        id: String = UUID().uuidString,
        instrument: Instrument,
        transposedTo key: Key = .c
    ) {
        self.init(
            id: id,
            preset: .init(instrument: instrument),
            pattern: instrument.patterns.first ?? .init(),
            tracksKey: instrument.tracksKey,
            transposedTo: key
        )
    }
}
