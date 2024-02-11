import SwiftUI

struct TrackView: View {
    @Binding var track: Track
    @Binding var playhead: Beats
    let beatSize: CGFloat
    
    var body: some View {
        HStack {
            let imageSize = beatSize * 0.7
            Image(track.instrument)
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding((beatSize - imageSize) / 2)
                .foregroundStyle(track.instrument.color)
            ForEach(0..<Int(track.length.rawValue.rounded(.up)), id: \.self) { i in
                let beatRange = Beats(i)..<Beats(i + 1)
                let shape = RoundedRectangle(cornerRadius: ViewConstants.cornerRadius)
                let color = track.instrument.color
                shape
                    .strokeBorder(
                        beatRange.contains(playhead)
                            ? color
                            : color.opacity(0.5),
                        lineWidth: 2
                    )
                    .background(shape.foregroundStyle(
                        !track.findEvents(in: beatRange).isEmpty
                            ? color
                            : color.opacity(0.15)
                    ))
                    .frame(width: beatSize, height: beatSize)
                    .onTapGesture {
                        track.replaceEvents(in: beatRange, with: Event())
                    }
            }
        }
    }
}

#Preview {
    TrackView(track: .constant(.init()), playhead: .constant(0), beatSize: 50.0)
        .preferredColorScheme(.dark)
}
