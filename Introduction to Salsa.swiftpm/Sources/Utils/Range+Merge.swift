extension Range {
    func merging(_ rhs: Self) -> Self {
        let minBound = Swift.min(lowerBound, rhs.lowerBound)
        let maxBound = Swift.max(upperBound, rhs.upperBound)
        return minBound..<maxBound
    }
}
