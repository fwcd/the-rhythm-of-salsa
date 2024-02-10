import SwiftUI

struct InstrumentTutorialScreen: View {
    let instrument: Instrument
    @Binding var route: ContentRoute?
    
    var body: some View {
        PageView(
            title: instrument.name,
            text: instrument.longDescription
        ) {
            Image(instrument)
        } navigation: {
            Button(instrument.isLast ? "Complete" : "Next") {
                route = instrument.isLast
                    ? .beatSequencer
                    : .instrumentTutorial(instrument.next)
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }
}

#Preview {
    InstrumentTutorialScreen(instrument: .cowbell, route: .constant(nil))
        .preferredColorScheme(.dark)
}
