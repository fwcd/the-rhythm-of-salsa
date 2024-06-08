import CoreGraphics

struct BeatSequencerOptions: Hashable {
    var tracks: TrackOptions = .init()
    var showsToolbar: Bool = true
    var usesCompactToolbarIcons: Bool = false
    var usesVerticalLayout: Bool = false
    var highlightedInstruments: Set<Instrument> = []
}
