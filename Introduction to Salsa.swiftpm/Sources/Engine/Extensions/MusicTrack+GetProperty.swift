import AVFoundation

extension MusicTrack {
    func getProperty<T>(_ property: UInt32) throws -> T? {
        var size = UInt32(MemoryLayout.size(ofValue: T.self))
        var data: T?
        guard MusicTrackGetProperty(self, property, &data, &size) == OSStatus(noErr) else {
            throw MusicTrackError.couldNotGetProperty(property)
        }
        return data
    }
}
