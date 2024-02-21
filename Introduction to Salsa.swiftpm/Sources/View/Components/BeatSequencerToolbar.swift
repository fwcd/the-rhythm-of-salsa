import OSLog
import SwiftUI
import UniformTypeIdentifiers

private let log = Logger(subsystem: "Introduction to Salsa", category: "View.BeatSequencerToolbar")

struct BeatSequencerToolbar: View {
    @Binding var isPlaying: Bool
    @Binding var model: BeatSequencerModel
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var midiImporterShown = false
    @State private var midiExporterShown = false
    
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
                isPlaying = false
                midiImporterShown = true
            } label: {
                Label("Import", systemImage: "square.and.arrow.down")
            }
            .fileImporter(isPresented: $midiImporterShown, allowedContentTypes: [.midi]) {
                do {
                    let url = try $0.get()
                    model = try BeatSequencerModel(midiFileURL: url)
                } catch {
                    log.warning("Could not load MIDI file: \(error)")
                }
            }
            .help("Imports a MIDI file")
            
            Button {
                isPlaying = false
                midiExporterShown = true
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            .fileExporter(
                isPresented: $midiExporterShown,
                document: MIDIFileDocument.parsed(model),
                contentType: .midi,
                defaultFilename: "Beat Sequence.mid"
            ) { _ in }
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
