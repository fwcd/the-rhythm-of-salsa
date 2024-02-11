import SwiftUI

struct SharedBeatSequencerView: View {
    var isInteractive: Bool = BeatSequencerDefaults.isInteractive
    var beatCount: Int = BeatSequencerDefaults.beatCount
    var padsPerBeat: Int = BeatSequencerDefaults.padsPerBeat
    var updater: (BeatSequencerEngine) -> Void = { _ in }
    
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        BeatSequencerView(
            model: $engine.model,
            playhead: $engine.playhead,
            isInteractive: isInteractive,
            beatCount: beatCount,
            padsPerBeat: padsPerBeat
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
