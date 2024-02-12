import AVFoundation

extension MusicTrack {
    var noteEvents: [(timestamp: MusicTimeStamp, message: MIDINoteMessage)] {
        get throws {
            var events: [(timestamp: MusicTimeStamp, message: MIDINoteMessage)] = []
            
            var iterator: MusicEventIterator?
            guard NewMusicEventIterator(self, &iterator) == OSStatus(noErr), let iterator else {
                throw MusicTrackError.couldNotFormEventIterator
            }
            
            var hasNext: DarwinBoolean = true
            
            while hasNext == true {
                guard MusicEventIteratorHasNextEvent(iterator, &hasNext) == OSStatus(noErr) else {
                    throw MusicTrackError.couldNotCheckIfEventIteratorHasNext
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
            }
            
            guard DisposeMusicEventIterator(iterator) == OSStatus(noErr) else {
                throw MusicTrackError.couldNotDisposeOfEventIterator
            }
            
            return events
        }
    }
}
