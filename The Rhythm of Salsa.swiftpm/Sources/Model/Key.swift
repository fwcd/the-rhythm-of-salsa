enum Key: String, Hashable, Codable, CaseIterable, CustomStringConvertible {
    case c = "C"
    case cSharpDFlat = "C#/Db"
    case d = "D"
    case eFlat = "Eb"
    case e = "E"
    case f = "F"
    case fSharpGFlat = "F#/Gb"
    case g = "G"
    case aFlat = "Ab"
    case a = "A"
    case bFlat = "Bb"
    case b = "B"
    
    var name: String {
        rawValue
    }
    var description: String {
        rawValue
    }
    
    func semitones(to key: Key) -> Int {
        key.ordinal - ordinal
    }
}
