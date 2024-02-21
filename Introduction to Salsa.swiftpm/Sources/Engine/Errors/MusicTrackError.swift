enum MusicTrackError: Error {
    case couldNotGetLoopInfo
    case couldNotSetLoopInfo
    case couldNotGetLength
    case couldNotSetLength
    case couldNotGetMute
    case couldNotSetMute
    case couldNotGetSolo
    case couldNotSetSolo
    case couldNotGetProperty(UInt32)
    case couldNotSetProperty(UInt32)
    case couldNotFormEventIterator
    case couldNotCheckIfEventIteratorHasCurrent
    case couldNotAdvanceEventIterator
    case couldNotGetEventInfo
    case couldNotCreateMIDIEvent(OffsetEvent)
}
