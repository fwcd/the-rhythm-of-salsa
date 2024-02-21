import SwiftUI

struct TrackControls: View {
    @Binding var track: Track
    var padSize: CGSize = ViewConstants.padSize
    let options: TrackOptions = .init()
    
    private var color: Color {
        track.instrument?.color ?? .primary
    }
    
    var body: some View {
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

