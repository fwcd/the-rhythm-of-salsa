import SwiftUI

struct BeatSequencerScreen: View {
    var body: some View {
        SharedBeatSequencerView { engine in
            engine.model.tracks = Instrument.allCases.map { Track(instrument: $0) }
        }
        .navigationTitle("Beat Sequencer")
    }
}

#Preview {
    BeatSequencerScreen()
        .preferredColorScheme(.dark)
}
