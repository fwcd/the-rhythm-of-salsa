import SwiftUI

struct BeatIndicatorsView: View {
    var padSize: CGFloat = 64
    var options: TrackOptions = .init()
    
    var body: some View {
        TrackRow(padSize: padSize, options: options) { position, beatRange in
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
    }
}
