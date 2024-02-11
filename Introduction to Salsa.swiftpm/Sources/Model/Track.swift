/// A sequencer track holding note events for a certain instrument.
struct Track: Hashable, Codable {
    var instrument: Instrument = .clave
    var offsetEvents: [OffsetEvent] = []
}
