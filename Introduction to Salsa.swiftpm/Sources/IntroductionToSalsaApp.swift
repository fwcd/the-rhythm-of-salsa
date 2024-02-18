import SwiftUI

private let engine = BeatSequencerEngine()

@main
struct IntroductionToSalsaApp: App {
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(engine)
        }
    }
}
