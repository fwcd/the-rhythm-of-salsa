struct PadPosition: Hashable {
    let beatIndex: Int
    let padInBeat: Int
}

extension Beats {
    init(_ position: PadPosition, padsPerBeat: Int) {
        self = Beats(position.beatIndex) + Beats(position.padInBeat) / Beats(padsPerBeat)
    }
}
