import SwiftUI

extension Image {
    init(_ instrument: Instrument) {
        self.init("Icons/\(instrument.name)")
    }
}
