/// An object that performs an action upon being dropped.
@propertyWrapper
class Guard<Value> {
    let wrappedValue: Value
    private let onDeinit: () -> Void
    
    init(wrappedValue: Value, _ onDeinit: @escaping () -> Void) {
        self.wrappedValue = wrappedValue
        self.onDeinit = onDeinit
    }
    
    deinit {
        onDeinit()
    }
}
