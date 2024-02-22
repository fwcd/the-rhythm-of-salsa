import Foundation
import AVFoundation

extension MIDIMetaEvent {
    static func create<T>(
        type: MIDIMetaEventType,
        encoding value: T
    ) throws -> Guard<UnsafeMutablePointer<MIDIMetaEvent>> where T: Encodable {
        let raw = try JSONEncoder().encode(value)
        return create(type: type, raw: raw)
    }
    
    mutating func decoded<T>(as type: T.Type) throws -> T where T: Decodable {
        return try JSONDecoder().decode(type, from: raw)
    }
}
