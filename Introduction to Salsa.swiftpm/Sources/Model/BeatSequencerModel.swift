struct BeatSequencerModel: Hashable, Codable {
    var beatsPerMinute: Beats = 180
    var tracks: [Track] = []
}
