import SwiftUI

struct BeatSequencerView: View {
    @Binding var model: BeatSequencerModel
    @Binding var playhead: Beats
    @Binding var isPlaying: Bool
    var options: BeatSequencerOptions = .init()
    
    var body: some View {
        SingleAxisGeometryReader { width in
            let padsPerRow = options.tracks.beatsPerRow * options.tracks.padsPerBeat
            let padWidth = width / (2 * CGFloat(padsPerRow))
            VStack(spacing: ViewConstants.largeSpace) {
                VStack(alignment: .leading, spacing: ViewConstants.smallSpace) {
                    BeatIndicatorsView(
                        playhead: $playhead,
                        padSize: CGSize(width: padWidth, height: padWidth),
                        options: options.tracks
                    )
                    ForEach($model.tracks) { $track in
                        let track = $track.wrappedValue
                        let isHighlighted = options.highlightedInstruments.isEmpty
                            || (track.instrument.map { options.highlightedInstruments.contains($0) } ?? false)
                        let isWrapped = track.beatCount > options.tracks.beatsPerRow
                        TrackView(
                            track: $track,
                            playhead: $playhead,
                            padSize: CGSize(width: padWidth, height: isWrapped ? padWidth / 4 : padWidth),
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
