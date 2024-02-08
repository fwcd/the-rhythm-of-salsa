import SwiftUI

struct IntroductionView: View {
    @Binding var route: ContentRoute?
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                let content = Group {
                    VStack(spacing: ViewConstants.mediumSpace) {
                        Text("Introduction to Salsa")
                            .font(.system(size: ViewConstants.titleFontSize))
                            .multilineTextAlignment(.center)
                        Text(
                            """
                            Salsa is a dance and a style of music that originated in Cuba. Popularized in the 1960s in NYC, many variants have emerged over time.
                            
                            This introduction will teach you about the fundamental elements of Salsa music, its rhythm and Cuban-style Salsa dancing.
                            """
                        )
                        .multilineTextAlignment(.center)
                        .font(.system(size: ViewConstants.subtitleFontSize))
                        .frame(maxWidth: 400)
                        Button("Get Started") {
                            route = .rhythmTutorial(.cowbell)
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                    }
                    Image("Dancers")
                        .clipShape(Circle())
                }
                if geometry.size.width < ViewConstants.horizontalBreakpoint {
                    VStack(spacing: ViewConstants.largeSpace) {
                        content
                    }
                } else {
                    HStack(spacing: geometry.size.width * 0.06) {
                        content
                    }
                }
            }
            .padding(ViewConstants.smallSpace)
            .frame(
                width: geometry.frame(in: .global).width,
                height: geometry.frame(in: .global).height
            )
        }
    }
}
