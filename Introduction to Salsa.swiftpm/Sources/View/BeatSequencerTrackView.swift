import SwiftUI

struct BeatSequencerTrackView: View {
    let instrument: Instrument
    
    var body: some View {
        EmptyView()
    }
}

#Preview {
    BeatSequencerTrackView(instrument: .clave)
        .preferredColorScheme(.dark)
}
