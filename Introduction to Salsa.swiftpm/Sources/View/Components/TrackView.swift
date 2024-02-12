import SwiftUI

struct TrackView: View {
    @Binding var track: Track
    @Binding var playhead: Beats
    var padSize: CGFloat = 64
    var options: TrackOptions = .init()
    
    private var beatCount: Int {
        Int(track.length.rawValue.rounded(.up))
    }
            
    private var loopedPlayhead: Beats {
        track.isLooping
            ? Beats(playhead.rawValue.truncatingRemainder(dividingBy: track.length.rawValue))
            : playhead
    }
    
    private struct Position: Hashable {
        let beatIndex: Int
        let padInBeat: Int
    }
    
    var body: some View {
        HStack {
            let imageSize = padSize * 0.7
            let color = track.instrument?.color ?? .primary
            if let instrument = track.instrument {
                Image(instrument)
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .padding((padSize - imageSize) / 2)
                    .foregroundStyle(color)
            }
            let padIndices = (0..<options.padCount).map { i in
                (
                    index: i,
                    position: Position(
                        beatIndex: i / options.padsPerBeat,
                        padInBeat: i % options.padsPerBeat
                    )
                )
            }
            ForEach(padIndices, id: \.position) { (i, position) in
                let beatRange = (Beats(i) / Beats(options.padsPerBeat))..<(Beats(i + 1) / Beats(options.padsPerBeat))
                PadView(
                    isActive: Binding {
                        !track.findEvents(in: beatRange).isEmpty
                    } set: {
                        if $0 {
                            track.replaceEvents(in: beatRange, with: Event(duration: 1 / Beats(options.padsPerBeat)))
                        } else {
                            track.removeEvents(in: beatRange)
                        }
                    },
                    isPlayed: beatRange.contains(loopedPlayhead),
                    velocity: track.findEvents(in: beatRange).first.map { CGFloat($0.event.velocity) / 127 } ?? 1,
                    color: color,
                    size: padSize,
                    beatInMeasure: position.beatIndex % 4,
                    padInBeat: position.padInBeat,
                    options: options.pads
                )
            }
        }
    }
}

#Preview {
    TrackView(
        track: .constant(.init()),
        playhead: .constant(0),
        padSize: 48
    )
    .preferredColorScheme(.dark)
}
