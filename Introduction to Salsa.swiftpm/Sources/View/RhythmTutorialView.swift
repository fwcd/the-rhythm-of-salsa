import SwiftUI

struct RhythmTutorialView: View {
    let instrument: Instrument
    
    var body: some View {
        PageView(
            title: instrument.name,
            text: instrument.longDescription
        )
    }
}

#Preview {
    RhythmTutorialView(instrument: .cowbell)
        .preferredColorScheme(.dark)
}
