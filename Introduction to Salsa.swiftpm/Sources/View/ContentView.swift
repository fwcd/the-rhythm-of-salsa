import SwiftUI

struct ContentView: View {
    @State private var route: ContentRoute? = .introduction
    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    @State private var instrumentTutorialExpanded: Bool = true
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $route) {
                NavigationLink(value: ContentRoute.introduction) {
                    Text("Introduction")
                }
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
