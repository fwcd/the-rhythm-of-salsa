import SwiftUI

struct BeatSequencerView: View {
    @Binding var model: BeatSequencerModel
    @Binding var playhead: Beats
    @Binding var isPlaying: Bool
    var options: BeatSequencerOptions = .init()
    
    var body: some View {
        SingleAxisGeometryReader { width in
            let padSize = width / (2 * CGFloat(options.tracks.padCount))
            VStack(spacing: ViewConstants.largeSpace) {
                VStack(alignment: .leading, spacing: ViewConstants.smallSpace) {
                    BeatIndicatorsView(
                        playhead: $playhead,
                        padSize: padSize,
                        options: options.tracks
                    )
                    ForEach($model.tracks) { $track in
                        let track = $track.wrappedValue
                        let isHighlighted = options.highlightedInstruments.isEmpty
                            || (track.instrument.map { options.highlightedInstruments.contains($0) } ?? false)
                        TrackView(
                            track: $track,
                            playhead: $playhead,
                            padSize: padSize,
                            options: options.tracks
                        )
                        .opacity(isHighlighted ? 1 : 0.3)
                        .grayscale(isHighlighted ? 0 : 1)
                    }
                    
                }
                if options.showsToolbar {
                    BeatSequencerToolbar(
                        isPlaying: $isPlaying,
                        mainVolume: $model.mainVolume,
                        beatsPerMinute: $model.beatsPerMinute
                    )
                }
            }
        }
    }
}

#Preview {
    BeatSequencerView(model: .constant(.init(tracks: [
        Track(),
        Track(instrument: .clave)
    ])), playhead: .constant(0), isPlaying: .constant(false))
}
