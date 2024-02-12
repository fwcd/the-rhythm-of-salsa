import SwiftUI

struct BeatSequencerScreen: View {
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        SharedBeatSequencerView()
            .onAppear {
                engine.model.tracks = Instrument.allCases.map { Track(preset: .init(instrument: $0)) }
            }
            .navigationTitle("Beat Sequencer")
    }
}

#Preview {
    BeatSequencerScreen()
        .environmentObject(BeatSequencerEngine())
        .preferredColorScheme(.dark)
}
