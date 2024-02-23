import SwiftUI

struct BeatSequencerScreen: View {
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        SharedBeatSequencerView()
            .onAppear {
                engine.shouldSyncUserModel = true
            }
            .navigationTitle("Beat Sequencer")
    }
}

#Preview {
    BeatSequencerScreen()
        .environmentObject(BeatSequencerEngine())
        .preferredColorScheme(.dark)
}
