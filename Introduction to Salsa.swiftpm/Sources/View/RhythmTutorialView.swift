import SwiftUI

struct RhythmTutorialView: View {
    let instrument: Instrument
    
    var body: some View {
        Text(instrument.description)
            .font(.system(size: ViewConstants.titleFontSize))
    }
}

#Preview {
    RhythmTutorialView(instrument: .cowbell)
        .preferredColorScheme(.dark)
}
