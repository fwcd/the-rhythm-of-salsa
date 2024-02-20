import SwiftUI

struct BeatSequencerView: View {
    @Binding var model: BeatSequencerModel
    @Binding var playhead: Beats
    var options: BeatSequencerOptions = .init()
    
    var body: some View {
        SingleAxisGeometryReader { width in
            let padSize = width / (2 * CGFloat(options.tracks.padCount))
            VStack(alignment: .leading, spacing: ViewConstants.smallSpace) {
                TrackRow(options: options.tracks, padSize: padSize) { position, beatRange in
                    Group {
                        if position.padInBeat == 0 {
                            Text(String(1 + position.beatIndex))
                        } else {
                            Text("+")
                                .opacity(0.3)
                        }
                    }
                    .frame(width: padSize)
                }
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
        }
    }
}

#Preview {
    BeatSequencerView(model: .constant(.init(tracks: [
        Track(),
        Track(instrument: .clave)
    ])), playhead: .constant(0))
}
