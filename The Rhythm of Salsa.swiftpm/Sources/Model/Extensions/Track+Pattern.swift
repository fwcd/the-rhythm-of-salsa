import Foundation

extension Track {
    init(
        id: String = UUID().uuidString,
        preset: TrackPreset = .init(),
        pattern: Pattern,
        transposedTo key: Key? = nil
    ) {
        self.init(
            id: id,
            preset: preset
        )
        reset(to: pattern, transposedTo: key)
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
            transposedTo: key
        )
    }
    
    mutating func reset(
        to pattern: Pattern,
        transposedTo key: Key? = nil
    ) {
        if let length = pattern.length {
            preset.length = length
        }
        
        patternName = pattern.name
        volume = pattern.volume
        offsetEvents = pattern.offsetEvents
        
        if let key {
            transpose(by: pattern.key.semitones(to: key))
        }
    }
    
}
