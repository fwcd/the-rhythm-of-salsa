import SwiftUI

struct BeatSequencerToolbar: View {
    @Binding var isPlaying: Bool
    @Binding var model: BeatSequencerModel
    
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
            
            TrackKnob(value: $model.mainVolume, defaultValue: 1)
                .foregroundStyle(Color.accentColor)
                .padding(.horizontal, ViewConstants.smallSpace)
                .help("The main volume")
            
            Group {
                TextField("BPM", value: $model.beatsPerMinute.rawValue, format: .number)
                    .multilineTextAlignment(.trailing)
                Stepper("BPM", value: $model.beatsPerMinute, in: 60...300)
            }
            .help("The sequencer's beats per minute")
            
            Divider()
            
            Button {
                // TODO
            } label: {
                Label("Import", systemImage: "square.and.arrow.down")
            }
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
        model: .constant(.init())
    )
}
