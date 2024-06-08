import CoreGraphics

struct BeatSequencerOptions: Hashable {
    var tracks: TrackOptions = .init()
    var showsToolbar: Bool = true
    var usesCompactToolbarIcons: Bool = false
    var usesVerticalToolbarLayout: Bool = false
    var highlightedInstruments: Set<Instrument> = []
}
