import SwiftUI

struct ContentView: View {
    @State private var route: ContentRoute? = .introduction
    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    @State private var instrumentTutorialExpanded: Bool = true
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $route) {
                NavigationLink("Introduction", value: ContentRoute.introduction)
                    .tag(ContentRoute.introduction)
                DisclosureGroup("The Instruments", isExpanded: $instrumentTutorialExpanded) {
                    ForEach(Instrument.allCases, id: \.self) { instrument in
                        NavigationLink(value: ContentRoute.rhythmTutorial(instrument)) {
                            Image(instrument)
                                .renderingMode(.template)
                                .resizable()
                                .foregroundStyle(.primary)
                                .frame(
                                    width: ViewConstants.sidebarIconSize,
                                    height: ViewConstants.sidebarIconSize
                                )
                            Text(instrument.name)
                        }
                        .tag(ContentRoute.rhythmTutorial(instrument))
                    }
                }
            }
        } detail: {
            switch route {
            case .introduction:
                IntroductionView(route: $route)
            case .rhythmTutorial(let instrument):
                InstrumentTutorialView(instrument: instrument)
            case nil:
                EmptyView()
            }
        }
    }
}
