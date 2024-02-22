import CoreGraphics

extension CGFloat {
    init(_ beats: Beats) {
        self = CGFloat(beats.rawValue)
    }
}
