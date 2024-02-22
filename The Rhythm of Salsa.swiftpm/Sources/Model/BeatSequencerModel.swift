/// A beat sequence including a number of tracks, a tempo, a main volume and a key.
struct BeatSequencerModel: Hashable, Codable {
    var beatsPerMinute: Beats = 180
    var mainVolume: Double = 1
    var tracks: [Track] = []
    var key: Key = .c {
        willSet {
            tracks = tracks.map {
                $0.tracksKey ? $0.transposed(by: key.semitones(to: newValue)) : $0
            }
        }
    }
}
