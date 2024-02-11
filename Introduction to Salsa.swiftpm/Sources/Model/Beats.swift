import Foundation

struct Beats: Codable, Hashable, RawRepresentable {
    var rawValue: Double
}

extension Beats {
    init(_ value: Int) {
        self.init(rawValue: Double(value))
    }
}

extension Beats {
    init(_ value: Double) {
        self.init(rawValue: value)
    }
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
        Beats(lhs.rawValue + rhs.rawValue)
    }
    
    static func -(lhs: Beats, rhs: Beats) -> Beats {
        Beats(lhs.rawValue - rhs.rawValue)
    }
    
    static func +=(lhs: inout Beats, rhs: Beats) {
        lhs.rawValue += rhs.rawValue
    }
    
    static func -=(lhs: inout Beats, rhs: Beats) {
        lhs.rawValue -= rhs.rawValue
    }
}

extension Beats: Numeric {
    var magnitude: Beats { Beats(rawValue.magnitude) }
    
    init?<T>(exactly source: T) where T: BinaryInteger {
        guard let rawValue = Double(exactly: source) else { return nil }
        self.init(rawValue: rawValue)
    }
    
    static func *(lhs: Beats, rhs: Beats) -> Beats {
        Beats(lhs.rawValue * rhs.rawValue)
    }
    
    static func *=(lhs: inout Beats, rhs: Beats) {
        lhs.rawValue *= rhs.rawValue
    }
    
    static func /(lhs: Beats, rhs: Beats) -> Beats {
        Beats(lhs.rawValue / rhs.rawValue)
    }
    
    static func /=(lhs: inout Beats, rhs: Beats) {
        lhs.rawValue /= rhs.rawValue
    }
}

extension Beats: SignedNumeric {
    static prefix func -(operand: Beats) -> Beats {
        Beats(-operand.rawValue)
    }
    
    mutating func negate() {
        rawValue.negate()
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
        Beats(rawValue + n)
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
