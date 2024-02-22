import Foundation

enum MusicSequenceError: Error {
    case couldNotCreate
    case couldNotLoadMIDIFile(URL)
    case couldNotCreateMIDIFile(URL)
    case couldNotCreateMIDIData
    case couldNotGetBeatsPerMinute
    case couldNotGetTrackCount
    case couldNotGetTrack(Int)
    case couldNotGetTempoTrack
    case couldNotAddTempoEvent
    case couldNotAddNewTrack
}
