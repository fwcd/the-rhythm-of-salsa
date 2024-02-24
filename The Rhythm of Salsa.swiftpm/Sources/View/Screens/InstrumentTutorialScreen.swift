import SwiftUI

struct InstrumentTutorialScreen: View {
    let instrument: Instrument
    @Binding var route: ContentRoute?
    
    @State private var textStage: Int = 0
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    private var hasPreviousStage: Bool {
        textStage > 0
    }
    
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
            Button("Back") {
                withAnimation {
                    if hasPreviousStage {
                        textStage -= 1
                    } else if instrument.isFirst {
                        route = .countTutorial
                    } else {
                        textStage = instrument.previous.tutorialDescription.count - 1
                        route = .instrumentTutorial(instrument.previous)
                    }
                }
            }
            .buttonStyle(BorderedButtonStyle())
            Button(isNearlyComplete ? "Complete Tutorial" : "Continue") {
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
            .buttonStyle(BorderedProminentButtonStyle())
        }
        .background {
            GeometryReader { geometry in
                Image(instrument)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(instrument.color(for: colorScheme))
                    .padding(ViewConstants.mediumSpace)
                    .frame(
                        width: geometry.frame(in: .global).width / 2,
                        height: geometry.frame(in: .global).height / 2,
                        alignment: .topTrailing
                    )
                    .frame(
                        width: geometry.frame(in: .global).width,
                        height: geometry.frame(in: .global).height,
                        alignment: .topTrailing
                    )
                    .opacity(colorScheme == .dark || instrument == .piano ? 0.05 : 0.1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(LinearGradient(
            colors: [instrument.color(for: colorScheme).opacity(0.2), .clear],
            startPoint: .top,
            endPoint: .center
        ))
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
