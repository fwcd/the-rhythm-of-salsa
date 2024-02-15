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
}
