import SwiftUI
import UniformTypeIdentifiers

enum MIDIFileDocument: Hashable {
    case raw(Data)
    case parsed(BeatSequencerModel)
    
    var data: Data {
        get throws {
            switch self {
            case .raw(let data): data
            case .parsed(let model): try model.midiData()
            }
        }
    }
}

extension MIDIFileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.midi] }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self = .raw(data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: try data)
    }
}
