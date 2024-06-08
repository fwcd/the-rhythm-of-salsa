extension Track {
    func isHighlighted(in tracks: [Track], options: BeatSequencerOptions) -> Bool {
        let isImplicitlyHighlighted = options.highlightedInstruments.isEmpty
        let isExplicitlyHighlighted = !options.highlightedInstruments.isEmpty
            && instrument.map { options.highlightedInstruments.contains($0) } ?? false
        let isMuteOrNonSolo = isMute || (!isSolo && tracks.contains(where: \.isSolo))
        let isHighlighted = !isMuteOrNonSolo && (isImplicitlyHighlighted || isExplicitlyHighlighted)
        return isHighlighted
    }
}
