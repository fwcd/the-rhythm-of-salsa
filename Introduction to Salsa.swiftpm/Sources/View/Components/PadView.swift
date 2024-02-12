import SwiftUI

struct PadView: View {
    @Binding var isActive: Bool
    let isPlayed: Bool
    var velocity: CGFloat = 1
    var color: Color = .primary
    var size: CGFloat = 64
    var beatInMeasure: Int = 0
    var padInBeat: Int = 0
    var options: PadOptions = .init()
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: ViewConstants.cornerRadius)
        Button {
            isActive = !isActive
        } label: {
            shape
                .strokeBorder(
                    isPlayed
                        ? color
                        : color.opacity(0.5),
                    lineWidth: 2
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
    }
}

#Preview {
    HStack {
        PadView(
            isActive: .constant(true),
            isPlayed: false
        )
        PadView(
            isActive: .constant(false),
            isPlayed: false
        )
        PadView(
            isActive: .constant(true),
            isPlayed: true
        )
        PadView(
            isActive: .constant(false),
            isPlayed: true
        )
    }
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
