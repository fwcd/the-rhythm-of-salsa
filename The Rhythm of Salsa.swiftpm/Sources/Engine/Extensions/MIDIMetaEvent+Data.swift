import AVFoundation

extension MIDIMetaEvent {
    var rawData: Data {
        withUnsafePointer(to: data) { dataPointer in
            Data(Array(UnsafeBufferPointer(start: dataPointer, count: Int(dataLength))))
        }
    }
}
