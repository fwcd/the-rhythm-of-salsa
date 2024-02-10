import SwiftUI

extension Instrument {
    var imageName: String {
        "Icons/\(name)"
    }
}

extension Image {
    init(_ instrument: Instrument) {
        self.init(instrument.imageName)
    }
}
