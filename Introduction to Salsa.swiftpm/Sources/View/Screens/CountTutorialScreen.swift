import SwiftUI

struct CountTutorialScreen: View {
    @Binding var route: ContentRoute?
    
    @State private var showDoubledPads: Bool = false
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        PageView(
            title: "The Count",
            text: (["The basic rhythm of Salsa music is divided into units of 8 beats, or two measures"]
                + (showDoubledPads ? ["To give the rhythm a more swingy feel, instruments often play on off-beats too, effectively resulting in 16 half beats."] : []))
                .joined(separator: "\n\n")
        ) {
        SharedBeatSequencerView(options: .init(
            tracks: .init(
                padsPerBeat: showDoubledPads ? 2 : 1,
                showsVolume: false,
                showsIcon: false,
                showsInstrumentName: false,
                showsPatternPicker: false,
                pads: .init(
                    isPressable: false
                )
            ),
            showsToolbar: false
        ))
        } navigation: {
            Button("Continue") {
                if !showDoubledPads {
                    withAnimation {
                        showDoubledPads = true
                    }
                } else {
                    route = .instrumentTutorial(Instrument.allCases.first!)
                }
            }
            .buttonStyle(BorderedButtonStyle())
        }
        .onAppear {
            engine.model.tracks = [
                Track(),
            ]
        }
    }
}

#Preview {
    CountTutorialScreen(route: .constant(nil))
        .environmentObject(BeatSequencerEngine())
        .preferredColorScheme(.dark)
}
