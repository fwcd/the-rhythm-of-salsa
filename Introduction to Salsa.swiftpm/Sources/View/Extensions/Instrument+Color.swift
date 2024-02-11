import SwiftUI

extension Instrument {
    var color: Color {
        switch self {
        case .clave: .orange
        case .cowbell: .yellow
        case .congas: .red
        case .bongos: .gray
        case .maracas: .green
        case .timbales: .blue
        case .piano: .primary
        }
    }
}

extension Color {
    init(_ instrument: Instrument) {
        self = instrument.color
    }
}
