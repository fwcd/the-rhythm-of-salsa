import SwiftUI

struct RhythmTutorialView: View {
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
    RhythmTutorialView(instrument: .cowbell)
        .preferredColorScheme(.dark)
}
