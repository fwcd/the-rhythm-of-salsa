import SwiftUI

struct TrackView: View {
    @Binding var track: Track
    @Binding var playhead: Beats
    var padSize: CGSize = ViewConstants.padSize
    var options: TrackOptions = .init()
    
    var body: some View {
        let color = track.instrument?.color ?? .primary
        let imageSize = padSize.width * 0.7
        TrackRow(beatCount: track.beatCount, padSize: padSize, options: options) { position, beatRange in
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
        } icon: {
            if let instrument = track.instrument {
                Image(instrument)
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .foregroundStyle(color)
            }
        } trailing: {
            if options.showsVolume {
                let defaultValue = track.instrument?.patterns.first { $0.name == track.patternName }?.volume
                TrackKnob(value: $track.volume, defaultValue: defaultValue, size: padSize.width * 0.8)
                    .foregroundStyle(color)
                    .frame(width: padSize.width, height: padSize.height)
                    .padding(.leading, ViewConstants.smallSpace)
            }
            if options.showsInstrumentName || options.showsPatternPicker {
                VStack(alignment: .leading) {
                    if options.showsInstrumentName,
                       let instrument = track.instrument {
                        Text(instrument.name)
                            .caption()
                            .padding(.horizontal, 4)
                    }
                    if options.showsPatternPicker {
                        PatternPicker(track: $track)
                    }
                }
            }
        }
    }
}

#Preview {
    TrackView(
        track: .constant(.init(instrument: .clave)),
        playhead: .constant(0)
    )
}
