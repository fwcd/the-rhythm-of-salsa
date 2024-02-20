import SwiftUI

struct BeatSequencerView: View {
    @Binding var model: BeatSequencerModel
    @Binding var playhead: Beats
    var options: BeatSequencerOptions = .init()
    
    var body: some View {
        GeometryReader { geometry in
            let padSize = geometry.size.width / (2 * CGFloat(options.tracks.padCount))
            VStack(alignment: .leading, spacing: ViewConstants.smallSpace) {
                ForEach($model.tracks) { $track in
                    let track = $track.wrappedValue
                    let isHighlighted = options.highlightedInstruments.isEmpty
                        || (track.instrument.map { options.highlightedInstruments.contains($0) } ?? false)
                    TrackView(
                        track: $track,
                        playhead: $playhead,
                        padSize: padSize,
                        options: options.tracks
                    )
                    .opacity(isHighlighted ? 1 : 0.3)
                    .blur(radius: isHighlighted ? 0 : 3)
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
