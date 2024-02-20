import SwiftUI

extension InsettableShape {
    func strokePad(isPlayed: Bool, color: Color) -> some View {
        strokeBorder(
            isPlayed
                ? color
                : color.opacity(0.5),
            lineWidth: isPlayed ? 2 : 1.5
        )
    }
}
