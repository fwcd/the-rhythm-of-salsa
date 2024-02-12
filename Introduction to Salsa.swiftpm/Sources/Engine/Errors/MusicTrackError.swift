enum MusicTrackError: Error {
    case couldNotGetLoopInfo
    case couldNotGetLength
    case couldNotGetProperty(UInt32)
    case couldNotFormEventIterator
    case couldNotCheckIfEventIteratorHasCurrent
    case couldNotAdvanceEventIterator
    case couldNotGetEventInfo
    case couldNotDisposeOfEventIterator
}
