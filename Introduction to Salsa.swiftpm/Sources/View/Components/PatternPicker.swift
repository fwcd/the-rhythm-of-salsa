import SwiftUI

struct PatternPicker: View {
    @Binding var track: Track
    
    var body: some View {
        Picker("Pattern", selection: Binding {
            track.patternName
        } set: { newPatternName in
            if let newPatternName,
               let newPattern = track.instrument?.patterns.first(where: { $0.name == newPatternName }) {
                track = Track(id: track.id, preset: track.preset, pattern: newPattern)
            } else {
                track.patternName = nil
            }
        }) {
            ForEach(track.instrument?.patterns ?? [], id: \.name) { pattern in
                Text(pattern.name)
                    .tag(pattern.name as String?)
            }
            Text("(custom)")
                .disabled(true)
                .tag(nil as String?)
        }
        .frame(width: 160, alignment: .leading)
    }
}
