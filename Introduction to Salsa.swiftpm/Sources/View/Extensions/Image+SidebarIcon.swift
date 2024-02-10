import SwiftUI

extension Image {
    func sidebarIcon() -> some View {
        self.renderingMode(.template)
            .resizable()
            .foregroundStyle(.primary)
            .frame(
                width: ViewConstants.sidebarIconSize,
                height: ViewConstants.sidebarIconSize
            )
    }
}
