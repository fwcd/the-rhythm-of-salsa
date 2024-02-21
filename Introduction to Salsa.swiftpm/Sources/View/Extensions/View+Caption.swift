import SwiftUI

extension View {
    func caption() -> some View {
        self.font(.caption)
            .foregroundStyle(.gray)
            .textCase(.uppercase)
    }
}
