extension Track {
    func cleared() -> Track {
        var track = self
        track.clear()
        return track
    }
    
    mutating func clear() {
        reset(to: emptyPattern)
    }
}
