/// An instrument in the beat sequencer.
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
}
