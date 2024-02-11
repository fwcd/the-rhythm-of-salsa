import SwiftUI

struct TrackView: View {
    @Binding var track: Track
    @Binding var playhead: Beats
    let padSize: CGFloat
    let padsPerBeat: Int
    
    private var beatCount: Int {
        Int(track.length.rawValue.rounded(.up))
    }
            
    private var padCount: Int {
        beatCount * padsPerBeat
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
            ForEach(0..<padCount, id: \.self) { i in
                let beatRange = (Beats(i) / Beats(padsPerBeat))..<(Beats(i + 1) / Beats(padsPerBeat))
                let padInBeat = i % padsPerBeat
                let beatInMeasure = (i / padsPerBeat) % 4
                PadView(
                    isActive: Binding {
                        !track.findEvents(in: beatRange).isEmpty
                    } set: {
                        if $0 {
                            track.replaceEvents(in: beatRange, with: Event(duration: 1 / Beats(padsPerBeat)))
                        } else {
                            track.removeEvents(in: beatRange)
                        }
                    },
                    isPlayed: beatRange.contains(loopedPlayhead),
                    size: padSize,
                    color: color,
                    padInBeat: padInBeat,
                    beatInMeasure: beatInMeasure
                )
            }
        }
    }
}

#Preview {
    TrackView(
        track: .constant(.init()),
        playhead: .constant(0),
        padSize: 50.0,
        padsPerBeat: 1
    )
    .preferredColorScheme(.dark)
}
