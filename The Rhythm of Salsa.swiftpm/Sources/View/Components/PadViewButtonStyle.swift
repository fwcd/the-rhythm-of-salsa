import SwiftUI

struct PadViewButtonStyle: ButtonStyle {
    let isActive: Bool
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .brightness(
                isHovered
                    ? isActive
                        ? 0.1
                        : 0.3
                    : 0
            )
            .onHover { isHovered in
                self.isHovered = isHovered
            }
    }
}
