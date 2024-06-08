import SwiftUI

struct BeatSequencerMixerView: View {
    @Binding var model: BeatSequencerModel
    var options: BeatSequencerOptions = .init()
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: ViewConstants.smallSpace) {
            ForEach($model.tracks) { $track in
                let track = $track.wrappedValue
                let isHighlighted = track.isHighlighted(in: model.tracks, options: options)
                let size = ViewConstants.smallPadSize
                VStack {
                    if let instrument = track.instrument {
                        Image(instrument)
                            .resizable()
                            .frame(width: size.width, height: size.height)
                            .foregroundStyle(track.instrument?.color(for: colorScheme) ?? .primary)
                            .unhighlight(!isHighlighted)

                    } else {
                        Spacer()
                            .frame(width: size.width, height: size.height)
                    }
                    TrackControls(
                        track: $track,
                        key: model.key,
                        padSize: size,
                        isHighlighted: isHighlighted,
                        options: options.mixerTracks
                    )
                }
            }
        }
    }
}

#Preview {
    BeatSequencerMixerView(model: .constant(.init(tracks: [
        Track(),
        Track(instrument: .clave)
    ])))
}
