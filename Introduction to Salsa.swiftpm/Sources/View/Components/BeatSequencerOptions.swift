import CoreGraphics

struct BeatSequencerOptions: Hashable {
    var isInteractive: Bool = BeatSequencerDefaults.isInteractive
    var beatCount: Int = BeatSequencerDefaults.beatCount
    var padsPerBeat: Int = BeatSequencerDefaults.padsPerBeat
    var padSize: CGFloat = BeatSequencerDefaults.padSize
    
    var padCount: Int {
        beatCount * padsPerBeat
    }
}
