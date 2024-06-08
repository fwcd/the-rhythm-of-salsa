import SwiftUI

struct TrackControls: View {
    @Binding var track: Track
    let key: Key
    var padSize: CGSize = ViewConstants.padSize
    var isHighlighted: Bool = true
    var options: TrackOptions = .init()
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var color: Color {
        track.instrument?.color(for: colorScheme) ?? .primary
    }
    
    var body: some View {
        if options.showsMuteSolo {
            VStack(spacing: 0) {
                Toggle("Mute", isOn: $track.isMute)
                    .foregroundStyle(track.isMute ? color : .gray)
                Toggle("Solo", isOn: $track.isSolo)
                    .foregroundStyle(track.isSolo ? color : .gray)
            }
            .caption()
            .toggleStyle(ButtonToggleStyle())
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, options.useMuteSoloPadding ? ViewConstants.smallSpace : 0)
        }
        Group {
            if options.showsVolume {
                let defaultValue = track.instrument?.patterns.first { $0.name == track.patternName }?.volume
                TrackKnob(value: $track.volume, defaultValue: defaultValue, size: padSize.width * 0.8)
                    .foregroundStyle(color)
                    .frame(width: padSize.width, height: padSize.height)
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
                        PatternPicker(track: $track, key: key)
                    }
                }
            }
        }
        .unhighlight(!isHighlighted)
    }
}

