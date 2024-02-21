import SwiftUI

extension View {
    func unhighlight(_ unhighlighted: Bool) -> some View {
        self.opacity(unhighlighted ? 0.3 : 1)
            .grayscale(unhighlighted ? 1 : 0)
    }
}
