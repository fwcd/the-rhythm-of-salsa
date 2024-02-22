import SwiftUI

struct KeyPicker: View {
    @Binding var key: Key
    
    var body: some View {
        Picker("Key", selection: $key) {
            ForEach(Key.allCases, id: \.self) { key in
                Text(key.name)
                    .tag(key.name)
            }
        }
        .padding(-8)
    }
}

#Preview {
    KeyPicker(key: .constant(.c))
}
