import SwiftUI

struct UnhighlightModifier: ViewModifier {
    var isEnabled: Bool = true
    
    func body(content: Content) -> some View {
        content
            .opacity(isEnabled ? 0.3 : 1)
            .grayscale(isEnabled ? 1 : 0)
    }
}

extension View {
    func unhighlight(_ isEnabled: Bool = true) -> some View {
        modifier(UnhighlightModifier(isEnabled: isEnabled))
    }
}
