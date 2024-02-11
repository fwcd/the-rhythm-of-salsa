struct BeatSequencerModel: Hashable, Codable {
    var beatsPerMinute: Double = 180
    var tracks: [Track] = []
}
