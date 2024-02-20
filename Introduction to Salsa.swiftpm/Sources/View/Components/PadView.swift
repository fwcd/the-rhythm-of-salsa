import SwiftUI

struct PadView: View {
    @Binding var isActive: Bool
    @Binding var velocity: CGFloat
    let isPlayed: Bool
    var color: Color = .primary
    var size: CGFloat = ViewConstants.padSize
    var beatInMeasure: Int = 0
    var padInBeat: Int = 0
    var options: PadOptions = .init()
    
    @State private var startVelocity: CGFloat? = nil
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: ViewConstants.smallCornerRadius)
        Button {
            isActive = !isActive
        } label: {
            shape
                .strokeBorder(
                    isPlayed
                        ? color
                        : color.opacity(0.5),
                    lineWidth: isPlayed ? 2 : 1.5
                )
                .background(
                    shape
                        .frame(width: size, height: velocity * size)
                        .position(x: size / 2, y: (size + (1 - velocity) * size) / 2)
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
                .frame(width: size, height: size)
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
                    
                    let startVelocity = self.startVelocity ?? velocity
                    self.startVelocity = startVelocity
                    
                    velocity = min(max(startVelocity - drag.translation.height / size, 0), 1)
                }
                .onEnded { _ in
                    startVelocity = nil
                    if velocity == 0 {
                        isActive = false
                    }
                }
        )
    }
}

#Preview {
    HStack {
        PadView(
            isActive: .constant(true),
            velocity: .constant(1),
            isPlayed: false
        )
        PadView(
            isActive: .constant(false),
            velocity: .constant(1),
            isPlayed: false
        )
        PadView(
            isActive: .constant(true),
            velocity: .constant(0.5),
            isPlayed: true
        )
        PadView(
            isActive: .constant(false),
            velocity: .constant(1),
            isPlayed: true
        )
    }
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
