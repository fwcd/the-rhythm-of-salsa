import SwiftUI

struct InstrumentTutorialView: View {
    let instrument: Instrument
    
    var body: some View {
        PageView(
            title: instrument.name,
            text: instrument.longDescription
        ) {
            Image(instrument)
        }
    }
}

#Preview {
    InstrumentTutorialView(instrument: .cowbell)
        .preferredColorScheme(.dark)
}
