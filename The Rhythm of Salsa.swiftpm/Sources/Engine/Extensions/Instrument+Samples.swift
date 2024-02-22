import Foundation

extension Instrument {
    var sampleNames: [String] {
        switch self {
        case .bongos: ["Bongos (High)", "Bongos (Low)"]
        case .clave: ["Clave"]
        case .congas: ["Conga"]
        case .cowbell: ["Cowbell"]
        case .maracas: ["Maraca 1", "Maraca 2"]
        case .timbales: ["Timbales 1", "Timbales 2"]
        case .piano: ["Piano"]
        }
    }
    
    var sampleURLs: [URL] {
        get throws {
            try memo([self]) {
                try sampleNames.map { name in
                    guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
                        throw SampleError.couldNotFindSample(name)
                    }
                    return url
                }
            }
        }
    }
}
