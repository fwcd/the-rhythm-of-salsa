import SwiftUI

struct SharedBeatSequencerView: View {
    var options: BeatSequencerOptions = .init()
    
    @State private var isPlaying = true
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        BeatSequencerView(
            model: $engine.model,
            playhead: $engine.playhead,
            isPlaying: $isPlaying,
            options: options
        )
        .onAppear {
            if isPlaying {
                engine.incrementPlaybackDependents()
            }
        }
        .onChange(of: isPlaying) { isPlaying in
            if isPlaying {
                engine.incrementPlaybackDependents()
            } else {
                engine.decrementPlaybackDependents()
            }
        }
        .onDisappear {
            if isPlaying {
                engine.decrementPlaybackDependents()
            }
        }
    }
}
