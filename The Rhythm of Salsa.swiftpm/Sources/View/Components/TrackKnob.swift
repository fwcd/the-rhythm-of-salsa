import SwiftUI

struct TrackKnob: View {
    @Binding var value: Double
    var defaultValue: Double? = nil
    var minValue: Double = 0
    var maxValue: Double = 1
    var sensitivity: Double = 1
    var halfCircleFraction: Double = 1 / 3
    var size: CGFloat = ViewConstants.knobSize
    
    @State private var delta: Double = 0
    @Environment(\.colorScheme) private var colorScheme
    
    private var valueWithDelta: Double {
        min(max(value + delta, minValue), maxValue)
    }
    
    private var normalizedValue: Double {
        (valueWithDelta - minValue) / (maxValue - minValue)
    }
    
    private var circleFraction: Double {
        2 * halfCircleFraction
    }
    
    private var angularValue: Angle {
        .radians(normalizedValue * circleFraction * 2 * .pi)
    }
    
    private var startAngle: Angle {
        .radians(-halfCircleFraction * 2 * .pi)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            let thickness = size / 16
            Circle()
                .fill(colorScheme == .light ? Color.white : .gray.opacity(0.3))
                .shadow(radius: ViewConstants.smallShadow)
                .frame(width: size, height: size)
            Arc(startAngle: .zero, endAngle: angularValue)
                .stroke(.foreground, lineWidth: thickness)
                .frame(width: size, height: size)
            Rectangle()
                .fill(.foreground)
                .frame(width: thickness, height: size * 0.4)
        }
        .rotationEffect(startAngle + angularValue)
        .gesture(
            TapGesture(count: 2)
                .onEnded {
                    resetToDefault()
                }
        )
        .simultaneousGesture(
            DragGesture()
                .onChanged { drag in
                    delta = Double(drag.translation.width - drag.translation.height) * 0.003 * sensitivity
                }
                .onEnded { _ in
                    value = valueWithDelta
                    delta = 0
                }
        )
        .contextMenu {
            Button("Set to Minimum Value") {
                value = minValue
            }
            Button("Set to Default Value") {
                resetToDefault()
            }
            .disabled(defaultValue == nil)
            Button("Set to Maximum Value") {
                value = maxValue
            }
        }
    }
    
    private func resetToDefault() {
        if let defaultValue {
            value = defaultValue
        }
    }
}

#Preview {
    TrackKnob(value: .constant(0.5))
}
