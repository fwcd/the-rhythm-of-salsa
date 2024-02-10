import SwiftUI

struct BeatSequencerView: View {
    // TODO: Should we make this a binding? Share the audio state?
    
    let instruments: [Instrument] = Instrument.allCases
    var beatCount: Int = 8
    
    var body: some View {
        GeometryReader { geometry in
            let beatSize = min(geometry.size.width, geometry.size.height) / (1.2 * CGFloat(beatCount))
            VStack(spacing: ViewConstants.smallSpace) {
                ForEach(instruments, id: \.self) { instrument in
                    BeatSequencerTrackView(
                        instrument: instrument,
                        beatCount: beatCount,
                        beatSize: beatSize
                    )
                }
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

#Preview {
    BeatSequencerView()
        .preferredColorScheme(.dark)
}
