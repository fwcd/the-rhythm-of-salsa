import SwiftUI

struct RhythmTutorialView: View {
    var body: some View {
        Text("The Cowbell")
            .font(.system(size: ViewConstants.titleFontSize))
    }
}

#Preview {
    RhythmTutorialView()
        .preferredColorScheme(.dark)
}
