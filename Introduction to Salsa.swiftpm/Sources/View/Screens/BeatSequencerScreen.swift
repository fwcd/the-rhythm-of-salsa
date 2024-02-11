import SwiftUI

struct BeatSequencerScreen: View {
    var body: some View {
        SharedBeatSequencerView()
            .navigationTitle("Beat Sequencer")
    }
}

#Preview {
    BeatSequencerScreen()
        .preferredColorScheme(.dark)
}
