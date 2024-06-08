import SwiftUI

struct PatternPicker: View {
    @Binding var track: Track
    let key: Key
    
    var body: some View {
        Picker("Pattern", selection: Binding {
            track.patternName
        } set: { newPatternName in
            if let newPatternName,
               let instrument = track.instrument,
               let newPattern = instrument.patterns.first(where: { $0.name == newPatternName }) {
                track.reset(to: newPattern, transposedTo: key)
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
        .labelsHidden()
        .padding(-8)
    }
}

#Preview {
    PatternPicker(track: .constant(Track(instrument: .clave)), key: .c)
}
