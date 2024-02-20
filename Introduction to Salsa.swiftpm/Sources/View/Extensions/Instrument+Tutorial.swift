extension Instrument {
    var tutorialDescription: [String] {
        switch self {
        case .clave: [
            #"The clave is one of the most fundamental instruments in Salsa music. Most commonly it plays a "2-3" pattern, i.e. 2 strokes on the first measure and 3 strokes on the second measure."#,
            #"Notice how the clave does not play on the first beat. The "off-beaty" feeling is a cornerstone of the polyrhythmic Salsa beat."#,
            "Now try editing the beat yourself by clicking the colored rectangular pads below. You can switch back to one of the predefined patterns using the drop-down menu on the right.",
        ]
        case .cowbell: [
            "While the clave often plays on the off-beats, the cowbell is generally on the beat. This provides a rhythmic framework that makes it easier to identify the beats by ear.",
        ]
        case .congas: [
            #"Congas are tall drums with a sonorous sound. Their rhythm, called "Tumbao", is in its simplest form characterized by playing the last two half-beats in each measure."#,
        ]
        case .bongos: [
            "Bongos are pairs of smaller drums that play a steady pattern with a stroke on every half-beat.",
        ]
        case .maracas: [
            "Maracas are shakers that play a similar pattern as the bongos, adding a steady groove to the rhythm.",
        ]
        case .timbales: [
            #"Timbales are drums that are usually hit on the side or "rim" of the drum, thereby producing a relatively high-pitched sound. They play a swingy rhythm named "cascara", which translates to "shell" in English, referring to this particular style of playing the drums."#,
        ]
        case .piano: [
            "The final layer is a piano that plays a simple riff, usually over four measures, alternating between chords.",
            "The chords making up this progression are, per convention, written as roman numerals referring to the nth major or major chord in the current key.",
            """
            This example is in the key of C, so our chords are
            vi = 6th (minor) = Am
            IV = 4th (major) = F
            V = 5th (major) = G
            """,
        ]
        }
    }
}
