import SwiftUI

extension View {
    func sidebarIcon(_ icon: Image) -> some View {
        Label {
            self
        } icon: {
            icon.sidebarIcon()
        }
    }
    
    func sidebarIcon(systemName: String) -> some View {
        sidebarIcon(Image(systemName: systemName))
    }
}
