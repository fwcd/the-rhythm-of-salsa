enum MusicTrackError: Error {
    case couldNotGetLoopInfo
    case couldNotGetLength
    case couldNotGetProperty(UInt32)
    case couldNotFormEventIterator
    case couldNotCheckIfEventIteratorHasNext
    case couldNotGetEventInfo
    case couldNotDisposeOfEventIterator
}
