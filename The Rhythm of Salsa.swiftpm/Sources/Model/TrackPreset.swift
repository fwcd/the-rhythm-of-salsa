struct TrackPreset: Hashable, Codable {
    var instrument: Instrument? = nil
    var length: Beats = 8
    var isLooping: Bool = true
    
    var shortDescription: String {
        "(\(instrument.map { "\($0)" } ?? "no instrument"), \(length))"
    }
}
