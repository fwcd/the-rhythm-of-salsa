import SwiftUI

struct StrokePadView: View {
    @Binding var isActive: Bool
    @Binding var velocity: CGFloat
    let isPlayed: Bool
    var color: Color = .primary
    var size: CGSize = ViewConstants.padSize
    var beatInMeasure: Int = 0
    var padInBeat: Int = 0
    var options: PadOptions = .init()
    
    @State private var delta: CGFloat = 0
    
    private var velocityWithDelta: CGFloat {
        min(max(velocity + delta, 0), 1)
    }
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: ViewConstants.smallCornerRadius)
        Button {
            isActive = !isActive
        } label: {
            shape
                .strokePad(isPlayed: isPlayed, color: color)
                .background(
                    shape
                        .frame(width: size.width, height: velocityWithDelta * size.height)
                        .position(
                            x: size.width / 2,
                            y: (size.height + (1 - velocityWithDelta) * size.height) / 2
                        )
                        .foregroundStyle(
                            isActive
                                ? color
                                : padInBeat == 0
                                    ? beatInMeasure == 0
                                        ? color.opacity(0.2)
                                        : color.opacity(0.15)
                                    : color.opacity(0.1)
                        )
                )
                .frame(width: size.width, height: size.height)
        }
        .buttonStyle(PadViewButtonStyle(isActive: isActive))
        .disabled(!options.isPressable)
        .highPriorityGesture(
            DragGesture()
                .onChanged { drag in
                    if !isActive {
                        isActive = true
                        velocity = 0
                    }
                    
                    delta = -drag.translation.height / size.height
                }
                .onEnded { _ in
                    velocity = velocityWithDelta
                    delta = 0
                    
                    if velocity == 0 {
                        isActive = false
                    }
                }
        )
    }
}

#Preview {
    HStack {
        StrokePadView(
            isActive: .constant(true),
            velocity: .constant(1),
            isPlayed: false
        )
        StrokePadView(
            isActive: .constant(false),
            velocity: .constant(1),
            isPlayed: false
        )
        StrokePadView(
            isActive: .constant(true),
            velocity: .constant(0.5),
            isPlayed: true
        )
        StrokePadView(
            isActive: .constant(false),
            velocity: .constant(1),
            isPlayed: true
        )
    }
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
