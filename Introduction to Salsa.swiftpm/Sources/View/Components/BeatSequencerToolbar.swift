import SwiftUI

struct BeatSequencerToolbar: View {
    @Binding var isPlaying: Bool
    @Binding var beatsPerMinute: Beats
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            Button {
                isPlaying = !isPlaying
            } label: {
                if isPlaying {
                    Label("Stop", systemImage: "stop")
                } else {
                    Label("Play", systemImage: "play")
                }
            }
            Divider()
            Stepper("\(Int(beatsPerMinute.rawValue)) BPM", value: $beatsPerMinute, in: 60...200)
            Divider()
            Button {
                // TODO
            } label: {
                Label("Import", systemImage: "square.and.arrow.down")
            }
            .disabled(true)
            Button {
                // TODO
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            .disabled(true)
        }
        .fixedSize()
        .buttonStyle(BorderedButtonStyle())
        .padding(ViewConstants.smallSpace)
        .background(
            .primary.opacity(colorScheme == .dark ? 0.05 : 0)
        )
        .clipShape(RoundedRectangle(cornerRadius: ViewConstants.largeCornerRadius))
        .overlay {
            if colorScheme == .light {
                RoundedRectangle(cornerRadius: ViewConstants.largeCornerRadius)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
            }
        }
    }
}

#Preview {
    BeatSequencerToolbar(
        isPlaying: .constant(false),
        beatsPerMinute: .constant(120)
    )
}
