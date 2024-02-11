import SwiftUI

struct TrackView: View {
    @Binding var track: Track
    @Binding var playhead: Beats
    let beatSize: CGFloat
    let squaresPerBeat: Int
    
    private var beatCount: Int {
        Int(track.length.rawValue.rounded(.up))
    }
            
    private var squareCount: Int {
        beatCount * squaresPerBeat
    }
    
    private var loopedPlayhead: Beats {
        track.isLooping
            ? Beats(playhead.rawValue.truncatingRemainder(dividingBy: track.length.rawValue))
            : playhead
    }
    
    var body: some View {
        HStack {
            let imageSize = beatSize * 0.7
            let color = track.instrument?.color ?? .primary
            if let instrument = track.instrument {
                Image(instrument)
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .padding((beatSize - imageSize) / 2)
                    .foregroundStyle(color)
            }
            ForEach(0..<squareCount, id: \.self) { i in
                let beatIndex = (i / squaresPerBeat) % 4
                let squareIndex = i % squaresPerBeat
                let beatRange = (Beats(i) / Beats(squaresPerBeat))..<(Beats(i + 1) / Beats(squaresPerBeat))
                let shape = RoundedRectangle(cornerRadius: ViewConstants.cornerRadius)
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
                            : squareIndex == 0
                                ? beatIndex == 0
                                    ? color.opacity(0.2)
                                    : color.opacity(0.15)
                                : color.opacity(0.1)
                    ))
                    .frame(width: beatSize, height: beatSize)
                    .onTapGesture {
                        if track.findEvents(in: beatRange).isEmpty {
                            track.replaceEvents(in: beatRange, with: Event(duration: 1 / Beats(squaresPerBeat)))
                        } else {
                            track.removeEvents(in: beatRange)
                        }
                    }
            }
        }
    }
}

#Preview {
    TrackView(
        track: .constant(.init()),
        playhead: .constant(0),
        beatSize: 50.0,
        squaresPerBeat: 1
    )
    .preferredColorScheme(.dark)
}
