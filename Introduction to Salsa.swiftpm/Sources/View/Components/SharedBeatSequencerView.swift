import SwiftUI

struct SharedBeatSequencerView: View {
    var isInteractive: Bool = true
    var updater: (BeatSequencerEngine) -> Void = { _ in }
    
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        BeatSequencerView(
            model: $engine.model,
            playhead: $engine.playhead,
            isInteractive: isInteractive
        )
        .onAppear {
            engine.incrementPlaybackDependents()
            updater(engine)
        }
        .onDisappear {
            engine.decrementPlaybackDependents()
        }
    }
}
