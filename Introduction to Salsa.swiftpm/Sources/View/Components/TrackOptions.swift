struct TrackOptions: Hashable {
    var beatCount: Int = 8
    var padsPerBeat: Int = 2
    var showsVolume: Bool = true
    var showsPatternPicker: Bool = true
    var pads: PadOptions = .init()
    
    var padCount: Int {
        beatCount * padsPerBeat
    }
}
