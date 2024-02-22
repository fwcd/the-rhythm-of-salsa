protocol TypedMutablePointer<Pointee>: TypedPointer {
    var pointee: Pointee { get set }
}

extension UnsafeMutablePointer: TypedMutablePointer {}
