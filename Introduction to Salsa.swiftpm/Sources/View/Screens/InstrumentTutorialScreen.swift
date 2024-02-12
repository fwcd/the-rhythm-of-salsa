import SwiftUI

struct InstrumentTutorialScreen: View {
    let instrument: Instrument
    @Binding var route: ContentRoute?
    
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        PageView(
            title: instrument.name,
            text: instrument.longDescription
        ) {
            SharedBeatSequencerView()
        } navigation: {
            Button(instrument.isLast ? "Complete" : "Next") {
                route = instrument.isLast
                    ? .beatSequencer
                    : .instrumentTutorial(instrument.next)
            }
            .buttonStyle(BorderedButtonStyle())
        }
        .onAppear {
            updateTracks(with: instrument)
        }
        .onChange(of: instrument) { instrument in
            updateTracks(with: instrument)
        }
    }
    
    private func updateTracks(with instrument: Instrument) {
        engine.model.tracks = [Track(preset: .init(instrument: instrument))]
    }
}

#Preview {
    InstrumentTutorialScreen(instrument: .cowbell, route: .constant(nil))
        .environmentObject(BeatSequencerEngine())
        .preferredColorScheme(.dark)
}
