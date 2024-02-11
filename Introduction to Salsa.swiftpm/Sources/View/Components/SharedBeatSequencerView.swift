import SwiftUI

struct SharedBeatSequencerView: View {
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        BeatSequencerView(
            model: $engine.model,
            playhead: $engine.playhead
        )
        .onAppear {
            engine.incrementPlaybackDependents()
        }
        .onDisappear {
            engine.decrementPlaybackDependents()
        }
    }
}
