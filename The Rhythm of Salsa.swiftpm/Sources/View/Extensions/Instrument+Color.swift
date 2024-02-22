import SwiftUI

extension Instrument {
    var color: Color {
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
    init(_ instrument: Instrument) {
        self = instrument.color
    }
}
