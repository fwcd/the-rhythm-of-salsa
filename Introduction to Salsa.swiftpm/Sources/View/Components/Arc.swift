import SwiftUI

struct Arc: Shape {
    let startAngle: Angle
    let endAngle: Angle
    var radius: CGFloat? = nil
    
    private var topAngle: Angle {
        .radians(0.75 * 2 * .pi)
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: radius ?? min(rect.width, rect.height) / 2,
                startAngle: topAngle - startAngle,
                endAngle: topAngle - endAngle,
                clockwise: true
            )
        }
    }
}

#Preview {
    Arc(startAngle: .radians(-0.4 * 2 * .pi), endAngle: .radians(0.4 * 2 * .pi))
        .stroke(lineWidth: 2)
}
