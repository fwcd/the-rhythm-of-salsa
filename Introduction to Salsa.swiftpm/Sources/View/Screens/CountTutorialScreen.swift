import SwiftUI

struct CountTutorialScreen: View {
    @Binding var route: ContentRoute?
    
    var body: some View {
        PageView(
            title: "The Count",
            text: "The basic rhythm of Salsa music is divided into units of 8 beats, or two measures"
        ) {
        SharedBeatSequencerView(options: .init(
            tracks: .init(
                padsPerBeat: 1,
                pads: .init(
                    isPressable: false
                )
            )
        )) { engine in
                engine.model.tracks = [
                    Track(),
                ]
            }
        } navigation: {
            Button("Continue") {
                route = .instrumentTutorial(Instrument.allCases.first!)
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }
}

#Preview {
    CountTutorialScreen(route: .constant(nil))
        .preferredColorScheme(.dark)
}
