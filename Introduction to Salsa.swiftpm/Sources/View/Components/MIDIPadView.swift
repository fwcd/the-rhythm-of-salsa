import SwiftUI

struct MIDIPadView: View {
    let offsetEvents: [OffsetEvent]
    let beatRange: Range<Beats>
    var isPlayed: Bool = false
    var color: Color = .primary
    var size: CGFloat = ViewConstants.padSize
    var notes: Int = 12
    
    private var beats: Beats {
        beatRange.upperBound - beatRange.lowerBound
    }
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: ViewConstants.smallCornerRadius)
        shape
            .strokePad(isPlayed: isPlayed, color: color)
            .overlay {
                let noteThickness = size / CGFloat(notes)
                ForEach(offsetEvents, id: \.self) { offsetEvent in
                    let width = size * CGFloat(offsetEvent.duration) / CGFloat(beats)
                    Rectangle()
                        .frame(
                            width: width,
                            height: noteThickness
                        )
                        .position(
                            x: size * CGFloat(offsetEvent.startOffset) / CGFloat(beats) + width / 2,
                            y: size * CGFloat(offsetEvent.event.key % UInt32(notes)) / CGFloat(notes)
                        )
                }
            }
            .frame(width: size, height: size)
            .clipShape(shape)
    }
}

#Preview {
    MIDIPadView(
        offsetEvents: Instrument.piano.patterns.first!.offsetEvents,
        beatRange: 0..<4
    )
}
