struct Beats: Codable, Hashable, RawRepresentable {
    var rawValue: Double
}

extension Beats: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.init(rawValue: Double(value))
    }
}

extension Beats: ExpressibleByFloatLiteral {
    init(floatLiteral value: Double) {
        self.init(rawValue: value)
    }
}
