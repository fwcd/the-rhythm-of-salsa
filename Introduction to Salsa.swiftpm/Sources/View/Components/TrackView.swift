import SwiftUI

struct TrackView: View {
    @Binding var track: Track
    @Binding var playhead: Beats
    var padSize: CGFloat = 64
    var options: TrackOptions = .init()
    
    private var beatCount: Int {
        Int(track.length.rawValue.rounded(.up))
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
                    } set: { isActive in
                        if isActive {
                            track.replaceEvents(in: beatRange, with: Event(duration: 1 / Beats(options.padsPerBeat)))
                        } else {
                            track.removeEvents(in: beatRange)
                        }
                        track.patternName = nil
                    },
                    isPlayed: beatRange.contains(track.looped(playhead)),
                    velocity: track.findEvents(in: beatRange).first.map { CGFloat($0.event.velocity) / 127 } ?? 1,
                    color: color,
                    size: padSize,
                    beatInMeasure: position.beatIndex % 4,
                    padInBeat: position.padInBeat,
                    options: options.pads
                )
            }
            if options.showsPatternPicker, let instrument = track.instrument {
                Picker("Pattern", selection: Binding {
                    track.patternName
                } set: { newPatternName in
                    if let newPatternName,
                       let newPattern = instrument.patterns.first(where: { $0.name == newPatternName }) {
                        track = Track(id: track.id, preset: track.preset, pattern: newPattern)
                    } else {
                        track.patternName = nil
                    }
                }) {
                    Text("Custom")
                        .disabled(true)
                        .tag(nil as String?)
                    ForEach(instrument.patterns, id: \.name) { pattern in
                        Text(pattern.name)
                            .tag(pattern.name as String?)
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
        padSize: 48
    )
    .preferredColorScheme(.dark)
}
