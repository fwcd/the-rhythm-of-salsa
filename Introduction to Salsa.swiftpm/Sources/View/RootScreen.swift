import SwiftUI

struct RootScreen: View {
    @State private var route: ContentRoute? = .introduction
    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    @State private var instrumentTutorialExpanded: Bool = true
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $route) {
                NavigationLink(value: ContentRoute.introduction) {
                    Text("Introduction")
                }
                NavigationLink("The Count", value: ContentRoute.countTutorial)
                DisclosureGroup(isExpanded: $instrumentTutorialExpanded) {
                    ForEach(Instrument.allCases, id: \.self) { instrument in
                        NavigationLink(value: ContentRoute.instrumentTutorial(instrument)) {
                            Text(instrument.name)
                                .sidebarIcon(Image(instrument))
                        }
                    }
                } label: {
                    Text("The Instruments")
                }
                NavigationLink(value: ContentRoute.beatSequencer) {
                    Text("Beat Sequencer")
                }
            }
        } detail: {
            switch route {
            case .introduction:
                IntroductionScreen(route: $route)
            case .countTutorial:
                CountTutorialScreen(route: $route)
            case .instrumentTutorial(let instrument):
                InstrumentTutorialScreen(instrument: instrument, route: $route)
            case .beatSequencer:
                BeatSequencerScreen()
            case nil:
                EmptyView()
            }
        }
    }
}
