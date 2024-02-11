import SwiftUI

struct TrackView: View {
    let track: Track
    let beatSize: CGFloat
    var activeBeat: Int = 0
    
    var body: some View {
        HStack {
            let imageSize = beatSize * 0.7
            Image(track.instrument)
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding((beatSize - imageSize) / 2)
                .foregroundStyle(track.instrument.color)
            ForEach(0..<Int(track.length.rawValue.rounded(.up)), id: \.self) { i in
                let shape = RoundedRectangle(cornerRadius: ViewConstants.cornerRadius)
                shape
                    .strokeBorder(
                        activeBeat == i
                            ? track.instrument.color
                            : track.instrument.color.opacity(0.5),
                        lineWidth: 2
                    )
                    .background(shape.foregroundStyle(track.instrument.color.opacity(0.15)))
                    .frame(width: beatSize, height: beatSize)
            }
        }
    }
}

#Preview {
    TrackView(track: .init(), beatSize: 50.0)
        .preferredColorScheme(.dark)
}
