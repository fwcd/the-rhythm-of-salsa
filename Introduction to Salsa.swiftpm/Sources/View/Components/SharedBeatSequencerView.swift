import SwiftUI

struct SharedBeatSequencerView: View {
    var options: BeatSequencerOptions = .init()
    var updater: (BeatSequencerEngine) -> Void = { _ in }
    
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        BeatSequencerView(
            model: $engine.model,
            playhead: $engine.playhead,
            options: options
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
