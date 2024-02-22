private class Memoizer {
    static let shared = Memoizer()
    
    private var storage: [[AnyHashable]: Any] = [:]
    
    private init() {}
    
    func memoValue<Value>(for key: [AnyHashable], function: @escaping () throws -> Value) rethrows -> Value {
        if let value = storage[key] as? Value {
            return value
        } else {
            let value = try function()
            storage[key] = value
            return value
        }
    }
}

func memo<Value>(
    file: String = #file,
    line: UInt = #line,
    _ dependencies: [any Hashable] = [],
    _ function: @escaping () throws -> Value
) rethrows -> Value {
    try Memoizer.shared.memoValue(for: [file, line] + dependencies.map { AnyHashable($0) }, function: function)
}
