extension Instrument {
    var tutorialDescription: [String] {
        switch self {
        case .clave:
            [
                #"The clave is one of the most fundamental instruments in Salsa music. Most commonly it plays a "2-3" pattern, i.e. 2 strokes on the first measure and 3 strokes on the second measure."#,
                #"Notice how the clave does not play on the first beat. The "off-beaty" feeling is a cornerstone of the polyrhythmic Salsa beat."#,
                "Now try editing the beat yourself by clicking the colored pads below.",
            ]
        default:
            []
        }
    }
    
    var examplePattern: [OffsetEvent] {
        switch self {
        case .clave: events(for: [1, 2, 4, 5.5, 7]) // 2-3 pattern
        case .cowbell: events(for: [0, 4])
        case .congas: events(for: [3, 3.5, 7, 7.5])
        case .bongos: events(for: Array(0..<16).map { Beats($0) / 2 }).enumerated().map { (i, event) in
            var event = event
            event.event.velocity /= i % 2 == 0 ? 2 : 3
            return event
        }
        // TODO: Remove default
        default: []
        }
    }
}

private func events(for pattern: [Beats]) -> [OffsetEvent] {
    pattern.map { OffsetEvent(event: Event(duration: 0.5), startOffset: $0) }
}
