import SwiftUI

struct ContentView: View {
    @State private var route: ContentRoute? = .introduction
    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    @State private var rhythmTutorialExpanded: Bool = true
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $route) {
                NavigationLink("Introduction", value: ContentRoute.introduction)
                    .tag(ContentRoute.introduction)
                DisclosureGroup("Rhythm Tutorial", isExpanded: $rhythmTutorialExpanded) {
                    ForEach(Instrument.allCases, id: \.self) { instrument in
                        NavigationLink(instrument.description, value: ContentRoute.rhythmTutorial(instrument))
                            .tag(ContentRoute.rhythmTutorial(instrument))
                    }
                }
            }
        } detail: {
            switch route {
            case .introduction:
                IntroductionView(route: $route)
            case .rhythmTutorial(let instrument):
                RhythmTutorialView(instrument: instrument)
            case nil:
                EmptyView()
            }
        }
    }
}
