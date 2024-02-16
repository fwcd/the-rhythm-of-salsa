import Foundation

extension Track {
    init(
        id: String = UUID().uuidString,
        preset: TrackPreset = .init(),
        pattern: Pattern
    ) {
        self.init(
            id: id,
            preset: preset,
            offsetEvents: pattern.offsetEvents
        )
    }
}
