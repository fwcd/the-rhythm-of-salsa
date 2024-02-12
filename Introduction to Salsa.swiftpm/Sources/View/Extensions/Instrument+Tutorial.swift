extension Instrument {
    var tutorialDescription: String {
        switch self {
        case .clave:
            "The clave is one of the most fundamental instruments in Salsa music. It dictates the rhythm and generally plays either a 2-3 or a 3-2 pattern. This refers to the numbers of strokes in the two measures, respectively."
        default:
            "" // TODO
        }
    }
    
    var examplePattern: [OffsetEvent] {
        switch self {
        case .clave:
            events(for: [1, 2, 4, 5.5, 7]) // 2-3 pattern
        // TODO: Remove default
        default:
            []
        }
    }
}

private func events(for pattern: [Beats]) -> [OffsetEvent] {
    pattern.map { OffsetEvent(event: Event(duration: 0.5), startOffset: $0) }
}
