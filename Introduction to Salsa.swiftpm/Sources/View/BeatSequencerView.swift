import SwiftUI

struct BeatSequencerView: View {
    // TODO: Should we make this a binding? Share the audio state?
    
    let instruments: [Instrument] = Instrument.allCases
    
    var body: some View {
        VStack(spacing: ViewConstants.smallSpace) {
            ForEach(instruments, id: \.self) { instrument in
                BeatSequencerTrackView(instrument: instrument)
            }
        }
    }
}

#Preview {
    BeatSequencerView()
        .preferredColorScheme(.dark)
}
