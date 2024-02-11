import SwiftUI

struct BeatSequencerView: View {
    @Binding var model: BeatSequencerModel
    @Binding var playhead: Beats
    var isInteractive: Bool = BeatSequencerDefaults.isInteractive
    var beatCount: Int = BeatSequencerDefaults.beatCount
    var padsPerBeat: Int = BeatSequencerDefaults.padsPerBeat
    
    var padCount: Int {
        beatCount * padsPerBeat
    }
    
    var body: some View {
        GeometryReader { geometry in
            let beatSize = min(geometry.size.width, geometry.size.height) / (1.2 * CGFloat(padCount))
            VStack(spacing: ViewConstants.smallSpace) {
                ForEach($model.tracks) { $track in
                    TrackView(
                        track: $track,
                        playhead: $playhead,
                        isInteractive: isInteractive,
                        padSize: beatSize,
                        padsPerBeat: 2
                    )
                }
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

#Preview {
    BeatSequencerView(model: .constant(.init(tracks: [Track()])), playhead: .constant(0))
        .preferredColorScheme(.dark)
}
