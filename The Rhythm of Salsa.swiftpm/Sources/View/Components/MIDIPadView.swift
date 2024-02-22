import SwiftUI

struct MIDIPadView: View {
    let offsetEvents: [OffsetEvent]
    let beatRange: Range<Beats>
    var isPlayed: Bool = false
    var color: Color = .primary
    var size: CGSize = ViewConstants.padSize
    var notes: Int = 12
    
    private var beats: Beats {
        beatRange.upperBound - beatRange.lowerBound
    }
    
    private var isCompact: Bool {
        size.height < size.width / 2
    }
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: ViewConstants.smallCornerRadius)
        shape
            .strokePad(isPlayed: isPlayed, color: color)
            .overlay {
                if !isCompact {
                    let noteThickness = size.height / CGFloat(notes)
                    ForEach(offsetEvents, id: \.self) { offsetEvent in
                        let width = size.width * CGFloat(offsetEvent.duration) / CGFloat(beats)
                        Rectangle()
                            .frame(
                                width: width,
                                height: noteThickness
                            )
                            .position(
                                x: size.width * CGFloat(offsetEvent.startOffset - beatRange.lowerBound) / CGFloat(beats) + width / 2,
                                y: size.height * CGFloat(offsetEvent.event.key % UInt32(notes)) / CGFloat(notes)
                            )
                    }
                }
            }
            .frame(width: size.width, height: size.height)
            .clipShape(shape)
    }
}

#Preview {
    MIDIPadView(
        offsetEvents: Instrument.piano.patterns.first!.offsetEvents,
        beatRange: 0..<4
    )
}
