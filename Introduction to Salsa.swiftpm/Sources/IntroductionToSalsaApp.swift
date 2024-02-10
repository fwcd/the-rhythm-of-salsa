import SwiftUI

@main
struct IntroductionToSalsaApp: App {
    @StateObject private var engine = BeatSequencerEngine()
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(engine)
                .preferredColorScheme(.dark)
        }
    }
}
