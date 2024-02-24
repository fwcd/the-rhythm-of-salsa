import SwiftUI

struct IntroductionScreen: View {
    @Binding var route: ContentRoute?
    
    @EnvironmentObject private var engine: BeatSequencerEngine
    @State private var isBackgroundAnimating = false
    
    var body: some View {
        PageView(
            title: AppConstants.name,
            text: """
            Salsa is a dance and a style of Latin music that originated in Cuba and was popularized in the 1960s in New York City.
            
            This introduction will teach you about the fundamental elements of Salsa music in an interactive environment that facilitates experimentation with new rhythms.
            """
        ) {} navigation: {
            Button("Get Started") {
                route = .countTutorial
            }
            .buttonStyle(BorderedProminentButtonStyle())
            Button("Skip Tutorial") {
                route = .beatSequencer
            }
            .buttonStyle(BorderedButtonStyle())
        } background: { isCompact in
            if !isCompact {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let total = CGFloat(Instrument.allCases.count)
                    let animation = isBackgroundAnimating
                        ? Animation.linear(duration: 120).repeatForever(autoreverses: false)
                        : .default
                    ForEach(Instrument.allCases, id: \.self) { instrument in
                        let angle = (CGFloat(instrument.ordinal) / total) * 2 * .pi
                        Image(instrument)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width / 12, height: width / 12)
                            .rotationEffect(.radians(isBackgroundAnimating ? 2 * .pi : 0))
                            .animation(animation, value: isBackgroundAnimating)
                            .position(
                                x: width / 2 + cos(angle) * width / 3,
                                y: height / 2 + sin(angle) * width / 3
                            )
                    }
                    .opacity(0.05)
                    .rotationEffect(.radians(isBackgroundAnimating ? -2 * .pi : 0))
                    .onAppear { isBackgroundAnimating = true }
                    .animation(animation, value: isBackgroundAnimating)
                    .frame(
                        width: geometry.frame(in: .global).width,
                        height: geometry.frame(in: .global).height
                    )
                }
            }
        }
    }
}
