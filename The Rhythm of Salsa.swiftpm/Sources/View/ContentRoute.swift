enum ContentRoute: Hashable, Codable {
    case introduction
    case countTutorial
    case instrumentTutorial(Instrument)
    case beatSequencer
}
