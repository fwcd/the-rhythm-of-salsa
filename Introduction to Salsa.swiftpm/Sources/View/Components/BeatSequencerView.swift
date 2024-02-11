import SwiftUI

struct BeatSequencerView: View {
    @Binding var model: BeatSequencerModel
    @Binding var playhead: Beats
    var beatCount: Int = 8
    var squaresPerBeat: Int = 2
    
    var body: some View {
        GeometryReader { geometry in
            let beatSize = min(geometry.size.width, geometry.size.height) / (1.2 * CGFloat(beatCount * squaresPerBeat))
            VStack(spacing: ViewConstants.smallSpace) {
                ForEach($model.tracks) { $track in
                    TrackView(
                        track: $track,
                        playhead: $playhead,
                        beatSize: beatSize,
                        squaresPerBeat: 2
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
