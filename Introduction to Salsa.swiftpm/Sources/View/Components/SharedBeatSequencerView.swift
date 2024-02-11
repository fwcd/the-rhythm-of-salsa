import SwiftUI

struct SharedBeatSequencerView: View {
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        BeatSequencerView(tracks: engine.tracks)
    }
}
