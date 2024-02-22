import AVFoundation

extension MIDIMetaEvent {
    var raw: Data {
        withUnsafePointer(to: data) { dataPointer in
            Data(Array(UnsafeBufferPointer(start: dataPointer, count: Int(dataLength))))
        }
    }
    
    static func create(
        metaEventType: UInt8,
        unused1: UInt8 = 0,
        unused2: UInt8 = 0,
        unused3: UInt8 = 0,
        raw: Data = Data([0])
    ) -> Guard<UnsafeMutablePointer<MIDIMetaEvent>> {
        precondition(raw.count >= 1)
        let size = MemoryLayout<MIDIMetaEvent>.size + raw.count - 1
        let pointer = UnsafeMutablePointer<MIDIMetaEvent>.allocate(capacity: size)
        
        pointer.pointee.dataLength = UInt32(raw.count)
        pointer.pointee.unused1 = unused1
        pointer.pointee.unused2 = unused2
        pointer.pointee.unused3 = unused3
        
        withUnsafeMutablePointer(to: &pointer.pointee.data) { dataPointer in
            let bufferPointer = UnsafeMutableBufferPointer(start: dataPointer, count: raw.count)
            raw.copyBytes(to: bufferPointer, count: raw.count)
        }
        
        return Guard(wrappedValue: pointer) {
            pointer.deallocate()
        }
    }
}
