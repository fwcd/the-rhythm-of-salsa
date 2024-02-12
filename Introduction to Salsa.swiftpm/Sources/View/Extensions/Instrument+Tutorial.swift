extension Instrument {
    var tutorialDescription: String {
        switch self {
        case .clave:
            "The clave is one of the most fundamental instruments in Salsa music. It dictates the rhythm and generally plays either a 2-3 or a 3-2 pattern. This refers to the numbers of strokes in the two measures, respectively."
        default:
            "" // TODO
        }
    }
}
