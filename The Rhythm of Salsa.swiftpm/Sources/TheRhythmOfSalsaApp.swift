import SwiftUI

private let engine = BeatSequencerEngine()

@main
struct TheRhythmOfSalsaApp: App {
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(engine)
        }
    }
}
