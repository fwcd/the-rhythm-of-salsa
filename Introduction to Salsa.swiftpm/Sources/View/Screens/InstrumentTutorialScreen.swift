import SwiftUI

struct InstrumentTutorialScreen: View {
    let instrument: Instrument
    @Binding var route: ContentRoute?
    
    @State private var textStage: Int = 1
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        PageView(
            title: instrument.name,
            text: instrument.tutorialDescription.prefix(textStage).joined(separator: "\n\n")
        ) {
            SharedBeatSequencerView()
        } navigation: {
            Button(instrument.isLast ? "Complete" : "Next") {
                withAnimation {
                    if textStage < instrument.tutorialDescription.count {
                        textStage += 1
                    } else {
                        textStage = 1
                        route = instrument.isLast
                            ? .beatSequencer
                            : .instrumentTutorial(instrument.next)
                    }
                }
            }
            .buttonStyle(BorderedButtonStyle())
        }
        .onAppear {
            updateTracks(with: instrument)
        }
        .onChange(of: instrument) { instrument in
            withAnimation {
                updateTracks(with: instrument)
            }
        }
    }
    
    private func updateTracks(with instrument: Instrument) {
        engine.model.tracks = instrument.prefix.map {
            Track(
                id: "$TutorialInstrument_\($0)",
                preset: .init(instrument: $0),
                pattern: $0.patterns.first!
            )
        }
    }
}

#Preview {
    InstrumentTutorialScreen(instrument: .cowbell, route: .constant(nil))
        .environmentObject(BeatSequencerEngine())
        .preferredColorScheme(.dark)
}
