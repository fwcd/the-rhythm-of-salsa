import AVFoundation

extension MIDIMetaEvent {
    var type: MIDIMetaEventType {
        get { .init(rawValue: metaEventType) }
        set { metaEventType = newValue.rawValue }
    }
    
    var raw: Data {
        withUnsafePointer(to: data) { dataPointer in
            Data(Array(UnsafeBufferPointer(start: dataPointer, count: Int(dataLength))))
        }
    }
    
    var text: String? {
        String(data: raw, encoding: .utf8)
    }
    
    static func create(
        type: MIDIMetaEventType,
        raw: Data = Data([0])
    ) -> Guard<UnsafeMutablePointer<MIDIMetaEvent>> {
        precondition(raw.count >= 1)
        let size = MemoryLayout<MIDIMetaEvent>.size + raw.count - 1
        let pointer = UnsafeMutablePointer<MIDIMetaEvent>.allocate(capacity: size)
        
        pointer.pointee.type = type
        pointer.pointee.dataLength = UInt32(raw.count)
        
        withUnsafeMutablePointer(to: &pointer.pointee.data) { dataPointer in
            let bufferPointer = UnsafeMutableBufferPointer(start: dataPointer, count: raw.count)
            raw.copyBytes(to: bufferPointer, count: raw.count)
        }
        
        return Guard(wrappedValue: pointer) {
            pointer.deallocate()
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
