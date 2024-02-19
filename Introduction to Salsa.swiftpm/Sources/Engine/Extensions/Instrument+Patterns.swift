import Foundation

extension Instrument {
    var patterns: [Pattern] {
        switch self {
        case .clave: [
            pattern("2-3 Pattern", beats: [1, 2, 4, 5.5, 7]),
            pattern("3-2 Pattern", beats: [0, 1.5, 3, 5, 6]),
        ]
        case .cowbell: [
            pattern("Beats", volume: 0.3, beats: [0, 2, 4, 6]),
            pattern("Downbeats", volume: 0.3, beats: [0, 4]),
        ]
        case .congas: [
            pattern("Tumbao", volume: 0.8, beats: [3, 3.5, 7, 7.5]),
        ]
        case .bongos: [
            pattern("Steady", beats: Array(0..<16).map { Beats($0) / 2 }) { $0 % 2 == 0 ? 0.8 : 0.4 },
        ]
        case .maracas: [
            pattern("Steady", beats: Array(0..<16).map { Beats($0) / 2 }) { $0 % 2 == 0 ? 0.8 : 0.4 },
        ]
        case .timbales: [
            pattern("Cascara", beats: [0, 1, 2, 2.5, 3.5, 4, 5, 5.5, 6.5, 7]),
        ]
        case .piano:
            memo([self]) {
                (Bundle.main.urls(forResourcesWithExtension: "mid", subdirectory: nil) ?? [])
                    .sorted { $0.absoluteString > $1.absoluteString }
                    .map { url in
                        let midi = try! BeatSequencerModel(midiFileURL: url)
                        return Pattern(
                            name: url.deletingPathExtension().lastPathComponent,
                            length: midi.tracks.first?.length,
                            offsetEvents: midi.tracks.first?.offsetEvents ?? []
                        )
                    }
            }
        }
    }
}

private func pattern(_ name: String = "Default", volume: Double = 1, beats: [Beats] = [], velocity: (Int) -> Double = { _ in 1 }) -> Pattern {
    Pattern(
        name: name,
        volume: volume,
        offsetEvents: beats.enumerated().map { (i, offset) in
            OffsetEvent(event: Event(velocity: UInt32(127 * velocity(i)), duration: 0.5), startOffset: offset)
        }
    )
}
