enum Instrument: String, Hashable, Codable, CustomStringConvertible, CaseIterable {
    case clave = "Clave"
    case cowbell = "Cowbell"
    case congas = "Congas"
    case bongos = "Bongos"
    case maracas = "Maracas"
    case timbales = "Timbales"
    case piano = "Piano"
    
    var name: String { rawValue }
    var description: String { rawValue }
    
    var longDescription: String {
        switch self {
        case .clave:
            "The clave is one of the most fundamental instruments in Salsa music. It dictates the rhythm and generally plays either a 2-3 or a 3-2 pattern. This refers to the numbers of strokes in the two measures, respectively."
        default:
            "" // TODO
        }
    }
}
