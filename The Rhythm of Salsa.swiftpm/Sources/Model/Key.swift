/// A key signature, ordered by the circle of fifths.
enum Key: String, Hashable, Codable, CaseIterable, CustomStringConvertible {
    case gFlat = "Gb"
    case dFlat = "Db"
    case aFlat = "Ab"
    case eFlat = "Eb"
    case bFlat = "Bb"
    case f = "F"
    case c = "C"
    case g = "G"
    case d = "D"
    case a = "A"
    case e = "E"
    case b = "B"
    
    var name: String {
        rawValue
    }
    var description: String {
        rawValue
    }
    
    var semitone: Int {
        switch self {
        case .dFlat:  1
        case .d:      2
        case .eFlat:  3
        case .e:      4
        case .f:      5
        case .gFlat:  6
        case .g:      7
        case .aFlat:  8
        case .a:      9
        case .bFlat: 10
        case .b:     11
        case .c:     12
        }
    }
    
    func semitones(to key: Key) -> Int {
        key.semitone - semitone
    }
}
