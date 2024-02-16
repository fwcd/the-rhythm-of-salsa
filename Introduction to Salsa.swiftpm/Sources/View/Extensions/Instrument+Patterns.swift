extension Instrument {
    var patterns: [[OffsetEvent]] {
        switch self {
        case .clave: [
            events(for: [1, 2, 4, 5.5, 7]), // 2-3 pattern
            events(for: [0, 1.5, 3, 5, 6]), // 3-2 pattern
        ]
        case .cowbell: [events(for: [0, 4])]
        case .congas: [events(for: [3, 3.5, 7, 7.5])]
        case .bongos: [events(for: Array(0..<16).map { Beats($0) / 2 }) { $0 % 2 == 0 ? 0.8 : 0.4 }]
        case .maracas: [events(for: [1, 1.5, 2, 2.5, 3.5, 4, 4.5, 5, 6, 6.5, 7, 7.5])]
        case .timbales: [events(for: [0, 1, 2, 2.5, 3.5, 4, 5, 5.5, 6.5, 7])]
        default: [[]]
        }
    }
}

private func events(for pattern: [Beats], velocity: (Int) -> Double = { _ in 1 }) -> [OffsetEvent] {
    pattern.enumerated().map { (i, offset) in
        OffsetEvent(event: Event(velocity: UInt32(127 * velocity(i)), duration: 0.5), startOffset: offset)
    }
}
