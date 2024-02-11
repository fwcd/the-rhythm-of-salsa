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
            ForEach(0..<options.padCount, id: \.self) { i in
                let beatRange = (Beats(i) / Beats(options.padsPerBeat))..<(Beats(i + 1) / Beats(options.padsPerBeat))
                let padInBeat = i % options.padsPerBeat
                let beatInMeasure = (i / options.padsPerBeat) % 4
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
                    color: color,
                    size: padSize,
                    beatInMeasure: beatInMeasure,
                    padInBeat: padInBeat,
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
