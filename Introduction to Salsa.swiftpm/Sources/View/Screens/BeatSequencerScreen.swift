import SwiftUI

struct BeatSequencerScreen: View {
    var body: some View {
        BeatSequencerView()
            .navigationTitle("Beat Sequencer")
    }
}

#Preview {
    BeatSequencerScreen()
        .preferredColorScheme(.dark)
}
