struct MIDIMetaEventType: RawRepresentable {
    // As per https://www.mixagesoftware.com/en/midikit/help/HTML/meta_events.html
    
    static let text = Self(rawValue: 0x01)
    static let copyright = Self(rawValue: 0x02)
    static let trackName = Self(rawValue: 0x03)
    static let instrumentName = Self(rawValue: 0x04)
    static let lyric = Self(rawValue: 0x05)
    static let marker = Self(rawValue: 0x06)
    static let cuePoint = Self(rawValue: 0x07)
    static let tempo = Self(rawValue: 0x51)
    static let timeSignature = Self(rawValue: 0x58)
    static let keySignature = Self(rawValue: 0x59)
    static let endOfTrack = Self(rawValue: 0x2F)
    
    let rawValue: UInt8
}
