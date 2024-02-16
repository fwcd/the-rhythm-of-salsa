extension Instrument {
    var patterns: [Pattern] {
        switch self {
        case .clave: [
            pattern("2-3 Pattern", beats: [1, 2, 4, 5.5, 7]),
            pattern("3-2 Pattern", beats: [0, 1.5, 3, 5, 6]),
        ]
        case .cowbell: [pattern("Downbeats", beats: [0, 4])]
        case .congas: [pattern("Tumbao", beats: [3, 3.5, 7, 7.5])]
        case .bongos: [pattern(beats: Array(0..<16).map { Beats($0) / 2 }) { $0 % 2 == 0 ? 0.8 : 0.4 }]
        case .maracas: [pattern(beats: [1, 1.5, 2, 2.5, 3.5, 4, 4.5, 5, 6, 6.5, 7, 7.5])]
        case .timbales: [pattern(beats: [0, 1, 2, 2.5, 3.5, 4, 5, 5.5, 6.5, 7])]
        default: [pattern()]
        }
    }
}

private func pattern(_ name: String = "Default", beats: [Beats] = [], velocity: (Int) -> Double = { _ in 1 }) -> Pattern {
    Pattern(
        name: name,
        offsetEvents: beats.enumerated().map { (i, offset) in
            OffsetEvent(event: Event(velocity: UInt32(127 * velocity(i)), duration: 0.5), startOffset: offset)
        }
    )
}
