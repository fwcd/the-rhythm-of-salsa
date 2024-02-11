/// An object that performs an action upon being dropped.
class Guard {
    private let onDeinit: () -> Void
    
    init(_ onDeinit: @escaping () -> Void) {
        self.onDeinit = onDeinit
    }
    
    deinit {
        onDeinit()
    }
}
