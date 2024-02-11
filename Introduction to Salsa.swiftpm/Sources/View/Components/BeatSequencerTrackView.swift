import SwiftUI

struct BeatSequencerTrackView: View {
    let instrument: Instrument
    let beatCount: Int
    let beatSize: CGFloat
    var activeBeat: Int = 0
    
    var body: some View {
        HStack {
            let imageSize = beatSize * 0.7
            Image(instrument)
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding((beatSize - imageSize) / 2)
                .foregroundStyle(instrument.color)
            ForEach(0..<beatCount, id: \.self) { i in
                let shape = RoundedRectangle(cornerRadius: ViewConstants.cornerRadius)
                shape
                    .strokeBorder(activeBeat == i ? instrument.color : instrument.color.opacity(0.5), lineWidth: 2)
                    .background(shape.foregroundStyle(instrument.color.opacity(0.15)))
                    .frame(width: beatSize, height: beatSize)
            }
        }
    }
}

#Preview {
    BeatSequencerTrackView(instrument: .clave, beatCount: 8, beatSize: 50.0)
        .preferredColorScheme(.dark)
}
