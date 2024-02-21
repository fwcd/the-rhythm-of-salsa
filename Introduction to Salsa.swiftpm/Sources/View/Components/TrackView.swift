import SwiftUI

struct TrackView: View {
    @Binding var track: Track
    @Binding var playhead: Beats
    var padSize: CGSize = ViewConstants.padSize
    var isHighlighted: Bool = true
    var options: TrackOptions = .init()
    
    private var color: Color {
        track.instrument?.color ?? .primary
    }
    
    var body: some View {
        let imageSize = padSize.width * 0.7
        TrackRow(beatCount: track.beatCount, padSize: padSize, options: options) { position, beatRange in
            Group {
                let isPlayed = beatRange.contains(track.looped(playhead))
                if track.instrument?.prefersMIDIView ?? false {
                    MIDIPadView(
                        offsetEvents: track.findEvents(in: beatRange),
                        beatRange: beatRange,
                        isPlayed: isPlayed,
                        color: color,
                        size: padSize
                    )
                } else {
                    StrokePadView(
                        isActive: Binding {
                            !track.findEvents(in: beatRange).isEmpty
                        } set: { isActive in
                            if isActive {
                                track.replaceEvents(in: beatRange, with: Event(duration: 1 / Beats(options.padsPerBeat)))
                            } else {
                                track.removeEvents(in: beatRange)
                            }
                            track.patternName = nil
                        },
                        velocity: Binding {
                            track.findEvents(in: beatRange).first.map { CGFloat($0.event.velocity) / 127 } ?? 1
                        } set: { velocity in
                            track.updateEvents(in: beatRange) { event in
                                event.velocity = UInt32(velocity * 127)
                            }
                        },
                        isPlayed: isPlayed,
                        color: color,
                        size: padSize,
                        beatInMeasure: position.beatIndex % 4,
                        padInBeat: position.padInBeat,
                        options: options.pads
                    )
                }
            }
            .unhighlight(!isHighlighted)
        } icon: {
            if let instrument = track.instrument {
                Image(instrument)
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .foregroundStyle(color)
                    .unhighlight(!isHighlighted)
            }
        } trailing: {
            TrackControls(
                track: $track,
                padSize: padSize,
                isHighlighted: isHighlighted,
                options: options
            )
        }
    }
}

#Preview {
    TrackView(
        track: .constant(.init(instrument: .clave)),
        playhead: .constant(0)
    )
}
