import SwiftUI

struct BeatIndicatorsView: View {
    @Binding var playhead: Beats
    var padSize: CGSize = ViewConstants.padSize
    var options: TrackOptions = .init()
    
    private var loopedPlayhead: Beats {
        playhead.truncatingRemainder(dividingBy: Beats(options.beatsPerRow))
    }
    
    var body: some View {
        TrackRow(padSize: padSize, options: options) { position, beatRange in
            Group {
                if position.padInBeat == 0 {
                    Text(String(1 + position.beatIndex))
                        .scaleEffect(beatRange.contains(loopedPlayhead) ? 1.2 : 1)
                } else {
                    Text("+")
                        .opacity(0.3)
                }
            }
            .frame(width: padSize.width)
            .onTapGesture {
                playhead = beatRange.lowerBound
            }
        }
    }
}
