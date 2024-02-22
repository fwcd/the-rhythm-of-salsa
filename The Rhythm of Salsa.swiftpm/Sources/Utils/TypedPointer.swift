protocol TypedPointer<Pointee> {
    associatedtype Pointee
    
    var pointee: Pointee { get }
}

extension UnsafePointer: TypedPointer {}
