enum Instrument: String, Hashable, Codable, CustomStringConvertible, CaseIterable {
    case cowbell = "Cowbell"
    case sonClave = "Son Clave"
    case congas = "Congas"
    case bongos = "Bongos"
    case maracas = "Maracas"
    case timbales = "Timbales"
    case piano = "Piano"
    
    var description: String {
        rawValue
    }
}
