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
    
    var ordinal: Int {
        Self.allCases.firstIndex(of: self)!
    }
    
    var next: Instrument {
        Self.allCases[(ordinal + 1) % Self.allCases.count]
    }
    
    var isLast: Bool {
        ordinal == Self.allCases.count - 1
    }
    
    var prefix: ArraySlice<Instrument> {
        Self.allCases[0..<(ordinal + 1)]
    }
}
