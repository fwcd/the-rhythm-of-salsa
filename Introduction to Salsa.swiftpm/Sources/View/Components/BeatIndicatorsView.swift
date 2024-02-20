import SwiftUI

struct BeatIndicatorsView: View {
    var options: TrackOptions = .init()
    var padSize: CGFloat = 64
    
    var body: some View {
        TrackRow(options: options, padSize: padSize) { position, beatRange in
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
