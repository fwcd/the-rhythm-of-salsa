import SwiftUI

struct BeatSequencerView: View {
    let tracks: [Track]
    var beatCount: Int = 8
    
    var body: some View {
        GeometryReader { geometry in
            let beatSize = min(geometry.size.width, geometry.size.height) / (1.2 * CGFloat(beatCount))
            VStack(spacing: ViewConstants.smallSpace) {
                ForEach(tracks, id: \.self) { track in
                    TrackView(
                        track: track,
                        beatSize: beatSize
                    )
                }
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

#Preview {
    BeatSequencerView(tracks: [Track()])
        .preferredColorScheme(.dark)
}
