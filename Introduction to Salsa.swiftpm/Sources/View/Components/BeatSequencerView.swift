import SwiftUI

struct BeatSequencerView: View {
    @Binding var model: BeatSequencerModel
    @Binding var playhead: Beats
    var options: BeatSequencerOptions = .init()
    
    var body: some View {
        GeometryReader { geometry in
            let beatSize = min(geometry.size.width, geometry.size.height) / (1.2 * CGFloat(options.tracks.padCount))
            VStack(spacing: ViewConstants.smallSpace) {
                ForEach($model.tracks) { $track in
                    TrackView(
                        track: $track,
                        playhead: $playhead,
                        options: options.tracks
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
