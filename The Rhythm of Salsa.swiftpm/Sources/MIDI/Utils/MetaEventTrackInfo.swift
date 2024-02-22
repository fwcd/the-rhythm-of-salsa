/// A custom structure used in our sequencer-specific (0x7F) meta event tags, to be stored as JSON.
struct MetaEventTrackInfo: Hashable, Codable {
    var isLooping: Bool?
    var isSolo: Bool?
    var isMute: Bool?
}
