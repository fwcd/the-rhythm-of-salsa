import SwiftUI

struct CaptionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundStyle(.gray)
            .textCase(.uppercase)
    }
}

extension View {
    func caption() -> some View {
        modifier(CaptionModifier())
    }
}
