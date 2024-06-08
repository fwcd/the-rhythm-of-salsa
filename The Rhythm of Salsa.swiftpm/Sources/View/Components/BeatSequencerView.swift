import SwiftUI

struct BeatSequencerView: View {
    @Binding var model: BeatSequencerModel
    @Binding var playhead: Beats
    @Binding var isPlaying: Bool
    var options: BeatSequencerOptions = .init()
    
    var body: some View {
        SingleAxisGeometryReader { width in
            let options = sizeAdjustedOptions(at: width)
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
                        let isImplicitlyHighlighted = options.highlightedInstruments.isEmpty
                        let isExplicitlyHighlighted = !options.highlightedInstruments.isEmpty
                            && track.instrument.map { options.highlightedInstruments.contains($0) } ?? false
                        let isMuteOrNonSolo = track.isMute || (!track.isSolo && model.tracks.contains(where: \.isSolo))
                        let isHighlighted = !isMuteOrNonSolo && (isImplicitlyHighlighted || isExplicitlyHighlighted)
                        let isWrapped = track.beatCount > options.tracks.beatsPerRow
                        TrackView(
                            track: $track,
                            playhead: $playhead,
                            key: model.key,
                            padSize: CGSize(width: padWidth, height: isWrapped ? padWidth / 4 : padWidth),
                            isHighlighted: isHighlighted,
                            options: options.tracks
                        )
                    }
                    
                }
                if options.showsMixer ?? false {
                    BeatSequencerMixerView(
                        model: $model,
                        options: options
                    )
                }
                if options.showsToolbar ?? true {
                    BeatSequencerToolbar(
                        isPlaying: $isPlaying,
                        model: $model,
                        options: options.toolbar
                    )
                }
            }
        }
    }
    
    private func sizeAdjustedOptions(at width: CGFloat) -> BeatSequencerOptions {
        var options = self.options
        if width < 800 {
            options.tracks.showsMuteSolo = false
            options.tracks.showsInstrumentName = false
            options.toolbar.usesCompactButtons = true
            options.showsMixer = options.showsMixer ?? true
        }
        if width < 600 {
            options.toolbar.usesVerticalLayout = true
            options.tracks.showsPatternPicker = false
        }
        if options.showsMixer ?? false {
            options.tracks.showsVolume = false
        }
        if options.toolbar.usesVerticalLayout {
            options.toolbar.usesCompactButtons = false
        }
        return options
    }
}

#Preview {
    BeatSequencerView(model: .constant(.init(tracks: [
        Track(),
        Track(instrument: .clave)
    ])), playhead: .constant(0), isPlaying: .constant(false))
}
