import SwiftUI

struct InstrumentTutorialScreen: View {
    let instrument: Instrument
    @Binding var route: ContentRoute?
    
    @State private var textStage: Int = 0
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    private var hasNextStage: Bool {
        textStage < instrument.tutorialDescription.count - 1
    }
    
    private var isLast: Bool {
        instrument.isLast
    }
    
    private var isNearlyComplete: Bool {
        !hasNextStage && isLast
    }
    
    var body: some View {
        PageView(
            title: instrument.name,
            text: textStage < instrument.tutorialDescription.count
                ? instrument.tutorialDescription[textStage]
                : ""
        ) {
            SharedBeatSequencerView(options: .init(
                tracks: .init(
                    showsMuteSolo: false,
                    showsVolume: false,
                    showsInstrumentName: false
                ),
                showsToolbar: false,
                highlightedInstruments: isNearlyComplete ? [] : [instrument]
            ))
        } navigation: {
            Button(isNearlyComplete ? "Complete Tutorial" : "Next") {
                withAnimation {
                    if hasNextStage {
                        textStage += 1
                    } else {
                        textStage = 0
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
        engine.shouldSyncUserModel = false
        engine.model = .init(tracks: instrument.prefix.map {
            Track(
                id: "$TutorialInstrument_\($0)",
                instrument: $0
            )
        })
    }
}

#Preview {
    InstrumentTutorialScreen(instrument: .cowbell, route: .constant(nil))
        .environmentObject(BeatSequencerEngine())
        .preferredColorScheme(.dark)
}
