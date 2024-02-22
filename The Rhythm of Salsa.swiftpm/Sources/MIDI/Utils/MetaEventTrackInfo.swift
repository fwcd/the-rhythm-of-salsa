/// A custom structure used in our sequencer-specific (0x7F) meta event tags, to be stored as JSON.
struct MetaEventTrackInfo: Hashable, Codable {
    enum CodingKeys: String, CodingKey {
        case instrument = "i"
        case patternName = "p"
        case isLooping = "l"
        case isSolo = "s"
        case isMute = "m"
        case volume = "v"
    }
    
    var instrument: Instrument?
    var patternName: String?
    var isLooping: Bool?
    var isSolo: Bool?
    var isMute: Bool?
    var volume: Double?
}
