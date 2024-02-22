import AVFoundation

extension MIDIMetaEvent {
    var text: String? {
        mutating get {
            String(data: raw, encoding: .utf8)
        }
    }
    
    static func create(
        type: MIDIMetaEventType,
        text: String
    ) -> Guard<UnsafeMutablePointer<MIDIMetaEvent>> {
        let raw = text.data(using: .utf8)!
        return create(type: type, raw: raw)
    }
}
