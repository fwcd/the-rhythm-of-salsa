import SwiftUI

struct TrackKnob: View {
    @Binding var value: Double
    var minValue: Double = 0
    var maxValue: Double = 1
    var sensitivity: Double = 1
    var halfCircleFraction: Double = 1 / 3
    var size: CGFloat = 64
    
    @State private var delta: Double = 0
    
    private var valueWithDelta: Double {
        value + delta
    }
    
    private var normalizedValueWithDelta: Double {
        valueWithDelta / (maxValue - minValue)
    }
    
    private var circleFraction: Double {
        2 * halfCircleFraction
    }
    
    private var angleFraction: Double {
        min(
            max(
                normalizedValueWithDelta * circleFraction - halfCircleFraction,
                -halfCircleFraction
            ),
            halfCircleFraction
        )
    }
    
    private var angle: Angle {
        .radians(angleFraction * 2 * .pi)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Circle()
                .fill(.gray.opacity(0.3))
                .frame(width: size, height: size)
            Rectangle()
                .fill(Color.accentColor)
                .frame(width: size / 16, height: size * 0.4)
        }
        .rotationEffect(angle)
        .gesture(
            DragGesture()
                .onChanged { drag in
                    delta = Double(drag.translation.width +  drag.translation.height) * 0.002 * sensitivity
                }
                .onEnded { _ in
                    value += delta
                    delta = 0
                }
        )
    }
}

#Preview {
    TrackKnob(value: .constant(0.5))
}
