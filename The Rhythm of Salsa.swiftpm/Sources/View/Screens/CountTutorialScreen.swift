import SwiftUI

struct CountTutorialScreen: View {
    @Binding var route: ContentRoute?
    
    @State private var showDoubledPads: Bool = false
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        PageView(
            title: "The Count",
            text: !showDoubledPads
                ? "The basic rhythm of Salsa music is divided into units of 8 beats. Salsa music is 4/4, i.e. every measure has 4 beats, therefore this is the equivalent of two measures."
                : "To give the rhythm a more swingy feel, instruments often play on off-beats too, effectively resulting in 16 half beats."
        ) {
        SharedBeatSequencerView(options: .init(
            tracks: .init(
                padsPerBeat: showDoubledPads ? 2 : 1,
                showsMuteSolo: false,
                showsVolume: false,
                showsIcon: false,
                showsInstrumentName: false,
                showsPatternPicker: false,
                pads: .init(
                    isPressable: false
                )
            ),
            showsMixer: false,
            showsToolbar: false
        ))
        } navigation: {
            Button("Back") {
                if showDoubledPads {
                    withAnimation {
                        showDoubledPads = false
                    }
                } else {
                    route = .introduction
                }
            }
            .buttonStyle(BorderedButtonStyle())
            Button("Continue") {
                if !showDoubledPads {
                    withAnimation {
                        showDoubledPads = true
                    }
                } else {
                    route = .instrumentTutorial(Instrument.allCases.first!)
                }
            }
            .buttonStyle(BorderedProminentButtonStyle())
        }
        .onAppear {
            engine.shouldSyncUserModel = false
            engine.model = .init(tracks: [
                Track(),
            ])
        }
    }
}

#Preview {
    CountTutorialScreen(route: .constant(nil))
        .environmentObject(BeatSequencerEngine())
        .preferredColorScheme(.dark)
}
