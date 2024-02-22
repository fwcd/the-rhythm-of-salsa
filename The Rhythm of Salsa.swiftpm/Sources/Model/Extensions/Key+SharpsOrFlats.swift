extension Key {
    /// The position in the circle of fifths or, equivalently, the numbers of sharps (if positive) or flats (if negative) in the corresponding key signature.
    var sharpsOrFlats: Int {
        ordinal - Key.c.ordinal
    }
    
    init?(sharpsOrFlats: Int) {
        self.init(ordinal: sharpsOrFlats + Key.c.ordinal)
    }
}
