import SwiftUI

struct IntroductionView: View {
    @Binding var route: ContentRoute?
    
    var body: some View {
        PageView(
            title: "Introduction to Salsa",
            text: """
            Salsa is a dance and a style of music that originated in Cuba and was popularized in the 1960s in New York City.
            
            This introduction will teach you about the fundamental elements of Salsa music, its rhythm and Cuban-style Salsa dancing.
            """
        ) {
            Image("Dancers")
                .clipShape(Circle())
        } navigation: {
            Button("Get Started") {
                route = .rhythmTutorial(.cowbell)
            }
            .buttonStyle(BorderedProminentButtonStyle())
        }
    }
}
