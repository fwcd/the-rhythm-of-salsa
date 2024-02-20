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
                incrementPlaybackDependents()
            }
        }
        .onChange(of: isPlaying) { isPlaying in
            if isPlaying {
                incrementPlaybackDependents()
            } else {
                decrementPlaybackDependents()
            }
        }
        .onDisappear {
            if isPlaying {
                decrementPlaybackDependents()
            }
        }
    }
    
    private func incrementPlaybackDependents() {
        engine.jumpToFirstLoop()
        engine.incrementPlaybackDependents()
    }
    
    private func decrementPlaybackDependents() {
        engine.decrementPlaybackDependents()
    }
}
