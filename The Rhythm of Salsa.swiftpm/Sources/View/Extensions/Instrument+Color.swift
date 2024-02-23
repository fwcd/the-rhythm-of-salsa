import SwiftUI

extension Instrument {
    func color(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .clave:
            .orange
        case .cowbell:
            colorScheme == .dark
                ? .yellow
                : .init(hue: 0.14, saturation: 1, brightness: 0.85)
        case .congas:
            .red
        case .bongos:
            .purple
        case .maracas:
            .blue
        case .timbales:
            .green
        case .piano:
            .primary
        }
    }
}

extension Color {
    init(_ instrument: Instrument, for colorScheme: ColorScheme) {
        self = instrument.color(for: colorScheme)
    }
}

#Preview {
    BeatSequencerView(
        model: .constant(.init(tracks: Instrument.allCases.map { instrument in
            Track(instrument: instrument)
        })),
        playhead: .constant(0),
        isPlaying: .constant(false)
    )
}
