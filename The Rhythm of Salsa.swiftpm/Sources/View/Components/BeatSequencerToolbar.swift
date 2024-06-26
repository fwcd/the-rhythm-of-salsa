import OSLog
import SwiftUI
import UniformTypeIdentifiers

private let log = Logger(subsystem: AppConstants.name, category: "View.BeatSequencerToolbar")

struct BeatSequencerToolbar: View {
    @Binding var isPlaying: Bool
    @Binding var model: BeatSequencerModel
    var options: BeatSequencerToolbarOptions = .init()
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var midiImporterShown = false
    @State private var midiExporterShown = false
    
    var body: some View {
        let content = Group {
            Button {
                isPlaying = !isPlaying
            } label: {
                if isPlaying {
                    Image(systemName: "stop")
                    if !options.usesCompactButtons {
                        Text("Stop")
                    }
                } else {
                    Image(systemName: "play")
                    if !options.usesCompactButtons {
                        Text("Play")
                    }
                }
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .help("Starts or stops the sequencer")
            
            Divider()
            
            HStack {
                TrackKnob(value: $model.mainVolume, defaultValue: 1)
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, ViewConstants.smallSpace)
                    .help("The main volume")
                
                KeyPicker(key: $model.key)
                    .buttonStyle(.plain)
                
                Group {
                    TextField("BPM", value: $model.beatsPerMinute.rawValue, format: .number)
                        .multilineTextAlignment(.trailing)
                    Stepper("BPM", value: $model.beatsPerMinute, in: 60...300)
                }
                .help("The sequencer's beats per minute")
            }
            .fixedSize()

            Divider()
            
            HStack {
                Button {
                    model.tracks = model.tracks.map { $0.cleared() }
                } label: {
                    Image(systemName: "trash")
                    if !options.usesCompactButtons {
                        Text("Clear")
                    }
                }
                
                Button {
                    isPlaying = false
                    midiImporterShown = true
                } label: {
                    Image(systemName: "square.and.arrow.down")
                    if !options.usesCompactButtons {
                        Text("Import")
                    }
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
                    Image(systemName: "square.and.arrow.up")
                    if !options.usesCompactButtons {
                        Text("Export")
                    }
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
        }
        
        Group {
            if options.usesVerticalLayout {
                VStack {
                    content
                }
            } else {
                HStack {
                    content
                }
            }
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
    VStack {
        ForEach([false, true], id: \.self) { usesVerticalLayout in
            BeatSequencerToolbar(
                isPlaying: .constant(false),
                model: .constant(.init()),
                options: .init(usesVerticalLayout: usesVerticalLayout)
            )
        }
    }
}
