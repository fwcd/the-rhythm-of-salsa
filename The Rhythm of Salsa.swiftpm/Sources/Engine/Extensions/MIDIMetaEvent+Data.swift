import AVFoundation

extension MIDIMetaEvent {
    var raw: Data {
        withUnsafePointer(to: data) { dataPointer in
            Data(Array(UnsafeBufferPointer(start: dataPointer, count: Int(dataLength))))
        }
    }
    
    static func create(metaEventType: UInt8, raw: Data) -> Guard<UnsafeMutablePointer<MIDIMetaEvent>> {
        let size = MemoryLayout<MIDIMetaEvent>.size + raw.count
        let pointer = UnsafeMutablePointer<MIDIMetaEvent>.allocate(capacity: size)
        
        pointer.pointee.dataLength = UInt32(raw.count)
        withUnsafeMutablePointer(to: &pointer.pointee.data) { dataPointer in
            let bufferPointer = UnsafeMutableBufferPointer(start: dataPointer, count: raw.count)
            raw.copyBytes(to: bufferPointer, count: raw.count)
        }
        
        return Guard(wrappedValue: pointer) {
            pointer.deallocate()
        }
    }
}
