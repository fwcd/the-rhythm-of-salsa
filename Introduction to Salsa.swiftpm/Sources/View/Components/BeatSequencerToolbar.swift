import SwiftUI

struct BeatSequencerToolbar: View {
    @Binding var isPlaying: Bool
    @Binding var mainVolume: Double
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
            .buttonStyle(BorderedProminentButtonStyle())
            .help("Starts or stops the sequencer")
            
            Divider()
            
            TrackKnob(value: $mainVolume, defaultValue: 1)
                .foregroundStyle(Color.accentColor)
                .padding(.horizontal, ViewConstants.smallSpace)
                .help("The main volume")
            
            Group {
                TextField("BPM", value: $beatsPerMinute.rawValue, format: .number)
                    .multilineTextAlignment(.trailing)
                Stepper("BPM", value: $beatsPerMinute, in: 60...300)
            }
            .help("The sequencer's beats per minute")
            
            Divider()
            
            Button {
                // TODO
            } label: {
                Label("Import", systemImage: "square.and.arrow.down")
            }
            .disabled(true)
            .help("Imports a MIDI file")
            
            Button {
                // TODO
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            .disabled(true)
            .help("Exports a MIDI file")
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
        mainVolume: .constant(1),
        beatsPerMinute: .constant(120)
    )
}
