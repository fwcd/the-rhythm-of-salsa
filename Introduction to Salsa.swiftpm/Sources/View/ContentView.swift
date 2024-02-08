import SwiftUI

struct ContentView: View {
    @State private var route: ContentRoute? = .introduction
    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(ContentRoute.allCases, id: \.self, selection: $route) { route in
                NavigationLink(route.displayName, value: route)
            }
        } detail: {
            switch route {
            case .introduction:
                IntroductionView(route: $route)
            case .rhythmTutorial:
                RhythmTutorialView()
            case nil:
                EmptyView()
            }
        }
    }
}
