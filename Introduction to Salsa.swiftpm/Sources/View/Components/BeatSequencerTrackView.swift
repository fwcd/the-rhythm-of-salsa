import SwiftUI

struct BeatSequencerTrackView: View {
    let instrument: Instrument
    let beatCount: Int
    let beatSize: CGFloat
    var activeBeat: Int = 0
    
    var body: some View {
        HStack {
            ForEach(0..<beatCount, id: \.self) { i in
                let shape = RoundedRectangle(cornerRadius: ViewConstants.cornerRadius)
                shape
                    .strokeBorder(activeBeat == i ? Color.primary : .gray, lineWidth: 2)
                    .background(shape.foregroundStyle(.primary.opacity(0.15)))
                    .frame(width: beatSize, height: beatSize)
            }
        }
    }
}

#Preview {
    BeatSequencerTrackView(instrument: .clave, beatCount: 8, beatSize: 50.0)
        .preferredColorScheme(.dark)
}