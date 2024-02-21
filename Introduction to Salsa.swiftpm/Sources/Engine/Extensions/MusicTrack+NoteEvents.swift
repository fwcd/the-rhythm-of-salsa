import AVFoundation
import OSLog

private let log = Logger(subsystem: "Introduction to Salsa", category: "Engine.MusicTrack+NoteEvents")

extension MusicTrack {
    var noteEvents: [(timestamp: MusicTimeStamp, message: MIDINoteMessage)] {
        get throws {
            var events: [(timestamp: MusicTimeStamp, message: MIDINoteMessage)] = []
            
            var iterator: MusicEventIterator?
            guard NewMusicEventIterator(self, &iterator) == OSStatus(noErr), let iterator else {
                throw MusicTrackError.couldNotFormEventIterator
            }
            
            defer {
                if DisposeMusicEventIterator(iterator) != OSStatus(noErr) {
                    log.warning("Could not dispose of MusicEventIterator in \(#function)")
                }
            }
            
            var hasCurrent: DarwinBoolean = true
            
            while true {
                guard MusicEventIteratorHasCurrentEvent(iterator, &hasCurrent) == OSStatus(noErr) else {
                    throw MusicTrackError.couldNotCheckIfEventIteratorHasCurrent
                }
                
                if hasCurrent == false {
                    break
                }
                var timestamp: MusicTimeStamp = 0
                var eventType: MusicEventType = 0
                var eventData: UnsafeRawPointer?
                var eventDataSize: UInt32 = 0
                guard MusicEventIteratorGetEventInfo(iterator, &timestamp, &eventType, &eventData, &eventDataSize) == OSStatus(noErr) else {
                    throw MusicTrackError.couldNotGetEventInfo
                }
                
                if eventType == kMusicEventType_MIDINoteMessage, let message = eventData?.load(as: MIDINoteMessage.self) {
                    events.append((
                        timestamp: timestamp,
                        message: message
                    ))
                }
                
                guard MusicEventIteratorNextEvent(iterator) == OSStatus(noErr) else {
                    throw MusicTrackError.couldNotAdvanceEventIterator
                }
            }
            
            return events
        }
    }
}
