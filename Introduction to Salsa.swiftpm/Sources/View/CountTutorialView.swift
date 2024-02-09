import SwiftUI

struct CountTutorialView: View {
    @Binding var route: ContentRoute?
    
    var body: some View {
        PageView(
            title: "The Count",
            text: "The basic rhythm of Salsa music is divided into units of 8 beats, or two measures"
        ) {
            // TODO: Add visualization
        } navigation: {
            Button("Continue") {
                route = .instrumentTutorial(Instrument.allCases.first!)
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }
}

#Preview {
    CountTutorialView(route: .constant(nil))
        .preferredColorScheme(.dark)
}
