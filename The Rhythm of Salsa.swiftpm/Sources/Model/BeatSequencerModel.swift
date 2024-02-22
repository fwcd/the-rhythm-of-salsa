struct BeatSequencerModel: Hashable, Codable {
    var beatsPerMinute: Beats = 180
    var mainVolume: Double = 1
    var tracks: [Track] = []
}
