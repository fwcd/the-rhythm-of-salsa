import SwiftUI

struct BeatSequencerMixerView: View {
    @Binding var model: BeatSequencerModel
    var options: BeatSequencerOptions = .init()
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            ForEach($model.tracks) { $track in
                let track = $track.wrappedValue
                let size = ViewConstants.smallPadSize
                VStack {
                    if let instrument = track.instrument {
                        Image(instrument)
                            .resizable()
                            .frame(width: size.width, height: size.height)
                            .foregroundStyle(track.instrument?.color(for: colorScheme) ?? .primary)

                    } else {
                        Spacer()
                            .frame(width: size.width, height: size.height)
                    }
                    TrackControls(
                        track: $track,
                        key: model.key,
                        padSize: size,
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
