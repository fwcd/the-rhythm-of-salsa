import SwiftUI

struct InstrumentTutorialView: View {
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
    InstrumentTutorialView(instrument: .cowbell, route: .constant(nil))
        .preferredColorScheme(.dark)
}
