import AVFoundation

extension MusicTrack {
    func getProperty<T>(_ property: UInt32, into data: inout T) throws {
        var size = UInt32(MemoryLayout.size(ofValue: T.self))
        guard MusicTrackGetProperty(self, property, &data, &size) == OSStatus(noErr) else {
            throw MusicTrackError.couldNotGetProperty(property)
        }
    }
    
    func setProperty<T>(_ property: UInt32, to data: inout T) throws {
        let size = UInt32(MemoryLayout.size(ofValue: T.self))
        guard MusicTrackSetProperty(self, property, &data, size) == OSStatus(noErr) else {
            throw MusicTrackError.couldNotSetProperty(property)
        }
    }
}
