import Foundation

struct Beats: Codable, Hashable, RawRepresentable {
    var rawValue: Double
}

extension Beats: CustomStringConvertible {
    var description: String {
        if rawValue == 1 {
            "1 beat"
        } else {
            String(format: "%.2f beats", rawValue)
        }
    }
}

extension Beats: AdditiveArithmetic {
    static let zero = Beats(rawValue: 0)
    
    static func +(lhs: Beats, rhs: Beats) -> Beats {
        Beats(rawValue: lhs.rawValue + rhs.rawValue)
    }
    
    static func -(lhs: Beats, rhs: Beats) -> Beats {
        Beats(rawValue: lhs.rawValue - rhs.rawValue)
    }
}

extension Beats: Comparable {
    static func <(lhs: Beats, rhs: Beats) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Beats: Strideable {
    func distance(to other: Beats) -> Double {
        other.rawValue - rawValue
    }
    
    func advanced(by n: Double) -> Beats {
        Beats(rawValue: rawValue + n)
    }
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
