import Foundation

enum MusicSequenceError: Error {
    case couldNotCreate
    case couldNotLoadMIDIFile(URL)
    case couldNotDisposeOf
    case couldNotGetBeatsPerMinute
    case couldNotGetTrackCount
    case couldNotGetTrack(Int)
}
