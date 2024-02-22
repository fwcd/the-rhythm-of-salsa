import AVFoundation
import OSLog

private let log = Logger(subsystem: AppConstants.name, category: "Engine.MusicTrack+NoteEvents")

extension MusicTrack {
    var midiTimestampEvents: [MIDITimestampEvent] {
        get throws {
            var events: [MIDITimestampEvent] = []
            
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
                guard MusicEventIteratorGetEventInfo(iterator, &timestamp, &eventType, &eventData, &eventDataSize) == OSStatus(noErr), let eventData else {
                    throw MusicTrackError.couldNotGetEventInfo
                }
                
                switch eventType {
                case kMusicEventType_Meta:
                    let pointer = UnsafeMutablePointer(mutating: eventData.assumingMemoryBound(to: MIDIMetaEvent.self))
                    events.append(.init(
                        timestamp: timestamp,
                        event: .meta(
                            type: pointer.pointee.type,
                            raw: pointer.pointee.raw
                        )
                    ))
                case kMusicEventType_MIDINoteMessage:
                    let message = eventData.load(as: MIDINoteMessage.self)
                    events.append(.init(
                        timestamp: timestamp,
                        event: .note(message)
                    ))
                case kMusicEventType_MIDIChannelMessage:
                    let message = eventData.load(as: MIDIChannelMessage.self)
                    events.append(.init(
                        timestamp: timestamp,
                        event: .channel(message)
                    ))
                default:
                    break
                }
                
                guard MusicEventIteratorNextEvent(iterator) == OSStatus(noErr) else {
                    throw MusicTrackError.couldNotAdvanceEventIterator
                }
            }
            
            return events
        }
    }
}
