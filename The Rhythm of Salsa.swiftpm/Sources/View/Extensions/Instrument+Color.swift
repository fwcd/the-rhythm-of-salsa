import SwiftUI

extension Instrument {
    func color(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .clave: .orange
        case .cowbell: .yellow
        case .congas: .red
        case .bongos: .purple
        case .maracas: .blue
        case .timbales: .green
        case .piano: .primary
        }
    }
}

extension Color {
    init(_ instrument: Instrument, for colorScheme: ColorScheme) {
        self = instrument.color(for: colorScheme)
    }
}
