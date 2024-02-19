import CoreGraphics

struct BeatSequencerOptions: Hashable {
    var tracks: TrackOptions = .init()
    var highlightedInstruments: Set<Instrument> = []
}
