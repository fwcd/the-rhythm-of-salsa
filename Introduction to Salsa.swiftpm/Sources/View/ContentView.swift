import SwiftUI

struct ContentView: View {
    @State private var route: ContentRoute? = .introduction
    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    @State private var instrumentTutorialExpanded: Bool = true
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $route) {
                NavigationLink("Introduction", value: ContentRoute.introduction)
                DisclosureGroup("The Instruments", isExpanded: $instrumentTutorialExpanded) {
                    ForEach(Instrument.allCases, id: \.self) { instrument in
                        NavigationLink(value: ContentRoute.instrumentTutorial(instrument)) {
                            Text(instrument.name)
                                .sidebarIcon(Image(instrument))
                        }
                    }
                }
                NavigationLink(value: ContentRoute.beatSequencer) {
                    Text("Beat Sequencer")
                        .sidebarIcon(systemName: "square.grid.3x3.square")
                }
            }
        } detail: {
            switch route {
            case .introduction:
                IntroductionView(route: $route)
            case .instrumentTutorial(let instrument):
                InstrumentTutorialView(instrument: instrument)
            case .beatSequencer:
                BeatSequencerView()
            case nil:
                EmptyView()
            }
        }
    }
}
