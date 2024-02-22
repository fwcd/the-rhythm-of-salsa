extension CaseIterable where Self: Equatable {
    var ordinal: AllCases.Index {
        Self.allCases.firstIndex(of: self)!
    }
}

extension CaseIterable where Self: Equatable, AllCases.Index == Int {
    var next: Self {
        Self.allCases[(ordinal + 1) % Self.allCases.count]
    }
    
    var isLast: Bool {
        ordinal == Self.allCases.count - 1
    }
    
    var prefix: Self.AllCases.SubSequence {
        Self.allCases[0..<(ordinal + 1)]
    }
    
    init?(ordinal: Int) {
        guard ordinal >= 0 && ordinal < Self.allCases.count else { return nil }
        self = Self.allCases[ordinal]
    }
}
