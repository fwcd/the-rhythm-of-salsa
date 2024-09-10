import SwiftUI

struct RootScreen: View {
    @State private var route: ContentRoute? = .introduction
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var instrumentTutorialExpanded: Bool = true
    
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $route) {
                NavigationLink("Introduction", value: ContentRoute.introduction)
                NavigationLink("The Count", value: ContentRoute.countTutorial)
                DisclosureGroup("The Instruments", isExpanded: $instrumentTutorialExpanded) {
                    ForEach(Instrument.allCases, id: \.self) { instrument in
                        NavigationLink(value: ContentRoute.instrumentTutorial(instrument)) {
                            Text(instrument.name)
                                .sidebarIcon(Image(instrument))
                        }
                    }
                }
                NavigationLink("Beat Sequencer", value: ContentRoute.beatSequencer)
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
        .onChange(of: route) { route in
            if route != .introduction {
                engine.boot()
            }
        }
    }
}
