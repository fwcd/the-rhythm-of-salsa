import CoreGraphics

struct TrackOptions: Hashable {
    var beatsPerRow: Int = 8
    var padsPerBeat: Int = 2
    var useMuteSoloPadding: Bool = true
    var showsMuteSolo: Bool = true
    var showsVolume: Bool = true
    var showsIcon: Bool = true
    var showsInstrumentName: Bool = true
    var showsPatternPicker: Bool = true
    var pads: PadOptions = .init()
}
