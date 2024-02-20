extension Track {
    var beatCount: Int {
        Int(length.rawValue.rounded(.up))
    }
}
