import SwiftUI

struct TrackView: View {
    @Binding var track: Track
    @Binding var playhead: Beats
    let beatSize: CGFloat
    
    private var loopedPlayhead: Beats {
        track.isLooping
            ? Beats(playhead.rawValue.truncatingRemainder(dividingBy: track.length.rawValue))
            : playhead
    }
    
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
                        beatRange.contains(loopedPlayhead)
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
                        if track.findEvents(in: beatRange).isEmpty {
                            track.replaceEvents(in: beatRange, with: Event())
                        } else {
                            track.removeEvents(in: beatRange)
                        }
                    }
            }
        }
    }
}

#Preview {
    TrackView(track: .constant(.init()), playhead: .constant(0), beatSize: 50.0)
        .preferredColorScheme(.dark)
}
