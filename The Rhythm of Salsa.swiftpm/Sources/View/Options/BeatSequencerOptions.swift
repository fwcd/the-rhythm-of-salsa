import CoreGraphics

struct BeatSequencerOptions: Hashable {
    var tracks: TrackOptions = .init()
    var mixerTracks: TrackOptions = .init(
        showsInstrumentName: false,
        showsPatternPicker: false
    )
    var toolbar: BeatSequencerToolbarOptions = .init()
    var showsMixer: Bool? = nil
    var showsToolbar: Bool? = nil
    var highlightedInstruments: Set<Instrument> = []
}
