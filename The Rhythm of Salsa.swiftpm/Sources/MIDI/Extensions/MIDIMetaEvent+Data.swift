import AVFoundation

extension MIDIMetaEvent {
    var type: MIDIMetaEventType {
        get { .init(rawValue: metaEventType) }
        set { metaEventType = newValue.rawValue }
    }
    
    var raw: Data {
        // We need to make it `mutating` to take `data` as `inout`, i.e. to actually get the reference. Sadly it doesn't seem to be trivial to get an `UnsafePointer` to an immutable self...
        mutating get {
            withUnsafePointer(to: &data) { dataPointer in
                Data(Array(UnsafeBufferPointer(start: dataPointer, count: Int(dataLength))))
            }
        }
    }
    
    var text: String? {
        mutating get {
            String(data: raw, encoding: .utf8)
        }
    }
    
    static func create(
        type: MIDIMetaEventType,
        raw: Data = Data([0])
    ) -> Guard<UnsafeMutablePointer<MIDIMetaEvent>> {
        precondition(raw.count >= 1)
        let size = MemoryLayout<MIDIMetaEvent>.size + raw.count + 8
        let pointer = UnsafeMutablePointer<MIDIMetaEvent>.allocate(capacity: size)
        
        pointer.pointee.type = type
        pointer.pointee.dataLength = UInt32(raw.count)
        
        withUnsafeMutablePointer(to: &pointer.pointee.data) { dataPointer in
            raw.copyBytes(to: dataPointer, count: raw.count)
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
