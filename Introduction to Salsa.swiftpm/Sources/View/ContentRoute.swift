enum ContentRoute: Hashable, Codable, CustomStringConvertible, CaseIterable {
    case introduction
    case rhythmTutorial
    
    var displayName: String {
        switch self {
        case .introduction: "Introduction"
        case .rhythmTutorial: "Rhythm Tutorial"
        }
    }
    
    var description: String {
        displayName
    }
}
