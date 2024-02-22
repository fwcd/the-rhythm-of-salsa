/// An object that performs an action upon being dropped.
@propertyWrapper
class Guard<Value> {
    private(set) var wrappedValue: Value
    private let onDeinit: () -> Void
    
    init(wrappedValue: Value, _ onDeinit: @escaping () -> Void) {
        self.wrappedValue = wrappedValue
        self.onDeinit = onDeinit
    }
    
    deinit {
        onDeinit()
    }
}

extension Guard: TypedPointer where Value: TypedPointer {
    var pointee: Value.Pointee {
        wrappedValue.pointee
    }
}

extension Guard: TypedMutablePointer where Value: TypedMutablePointer {
    var pointee: Value.Pointee {
        get { wrappedValue.pointee }
        set { wrappedValue.pointee = newValue }
    }
}
