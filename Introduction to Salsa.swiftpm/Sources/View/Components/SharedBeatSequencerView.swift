import SwiftUI

struct SharedBeatSequencerView: View {
    var options: BeatSequencerOptions = .init()
    
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        BeatSequencerView(
            model: $engine.model,
            playhead: $engine.playhead,
            options: options
        )
        .onAppear {
            engine.incrementPlaybackDependents()
        }
        .onDisappear {
            engine.decrementPlaybackDependents()
        }
    }
}
