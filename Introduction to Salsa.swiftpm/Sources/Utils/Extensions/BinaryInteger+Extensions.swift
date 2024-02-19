extension BinaryInteger {
    func greatestCommonDivisor(_ rhs: Self) -> Self {
        rhs == 0 ? self : rhs.greatestCommonDivisor(self % rhs)
    }
    
    func leastCommonMultiple(_ rhs: Self) -> Self {
        (self * rhs) / greatestCommonDivisor(rhs)
    }
}
