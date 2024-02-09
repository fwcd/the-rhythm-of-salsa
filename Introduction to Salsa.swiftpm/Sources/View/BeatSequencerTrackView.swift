import SwiftUI

struct BeatSequencerTrackView: View {
    let instrument: Instrument
    var activeBeat: Int = 0
    var beatCount: Int = 8
    
    var body: some View {
        HStack {
            ForEach(0..<beatCount, id: \.self) { i in
                let shape = RoundedRectangle(cornerRadius: ViewConstants.cornerRadius)
                shape
                    .strokeBorder(activeBeat == i ? .white : .gray, lineWidth: 2)
                    .background(shape.foregroundStyle(.white.opacity(0.2)))
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    BeatSequencerTrackView(instrument: .clave)
        .preferredColorScheme(.dark)
}
