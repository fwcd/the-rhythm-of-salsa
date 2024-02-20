import CoreGraphics

struct BeatSequencerOptions: Hashable {
    var tracks: TrackOptions = .init()
    var showsToolbar: Bool = true
    var highlightedInstruments: Set<Instrument> = []
}
