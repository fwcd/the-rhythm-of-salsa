import SwiftUI

struct IntroductionScreen: View {
    @Binding var route: ContentRoute?
    
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        PageView(
            title: AppConstants.name,
            text: """
            Salsa is a dance and a style of Latin music that originated in Cuba and was popularized in the 1960s in New York City.
            
            This introduction will teach you about the fundamental elements of Salsa music in an interactive environment that facilitates experimentation with new rhythms.
            """
        ) {
        } navigation: {
            Button("Get Started") {
                route = .countTutorial
            }
            .buttonStyle(BorderedProminentButtonStyle())
            Button("Skip Tutorial") {
                route = .beatSequencer
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }
}
