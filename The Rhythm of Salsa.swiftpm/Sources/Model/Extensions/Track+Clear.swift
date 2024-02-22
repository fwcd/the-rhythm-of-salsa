extension Track {
    func cleared() -> Track {
        Track(preset: preset, pattern: emptyPattern)
    }
    
    mutating func clear() {
        self = cleared()
    }
}
