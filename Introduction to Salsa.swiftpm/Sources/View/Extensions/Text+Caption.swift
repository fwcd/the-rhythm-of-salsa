import SwiftUI

extension Text {
    func caption() -> some View {
        self.font(.caption)
            .foregroundStyle(.gray)
            .textCase(.uppercase)
    }
}
