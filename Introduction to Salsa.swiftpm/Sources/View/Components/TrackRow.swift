import SwiftUI

struct TrackRow<Content, Icon, Trailing>: View where Content: View, Icon: View, Trailing: View {
    var beatCount: Int = 8
    var padSize: CGFloat = ViewConstants.padSize
    var options: TrackOptions = .init()
    @ViewBuilder var content: (PadPosition, Range<Beats>) -> Content
    @ViewBuilder var icon: () -> Icon
    @ViewBuilder var trailing: () -> Trailing
    
    var body: some View {
        VStack(alignment: .leading) {
            let beatsPerRow = options.beatsPerRow
            let padsPerBeat = options.padsPerBeat
            let fullRows = beatCount / beatsPerRow
            let partialRowBeats = beatCount % beatsPerRow
            let rows = fullRows + (partialRowBeats > 0 ? 1 : 0)
            ForEach(Array((0..<rows).map { $0 * beatsPerRow }.enumerated()), id: \.element) { (i, beatOffset) in
                HStack {
                    if options.showsIcon {
                        icon()
                            .frame(width: padSize, height: padSize)
                    }
                    let isPartialRow = i == rows - 1 && partialRowBeats > 0
                    let rowBeats = isPartialRow ? partialRowBeats : beatsPerRow
                    let rowPads = rowBeats * padsPerBeat
                    let padIndices = (0..<rowPads).map { i in
                        (
                            index: i,
                            position: PadPosition(
                                beatIndex: i / padsPerBeat + beatOffset,
                                padInBeat: i % padsPerBeat
                            )
                        )
                    }
                    ForEach(padIndices, id: \.position) { (i, position) in
                        let start = Beats(position, padsPerBeat: padsPerBeat)
                        let end = start + 1 / Beats(padsPerBeat)
                        let beatRange = start..<end
                        content(position, beatRange)
                    }
                    if i == 0 {
                        trailing()
                    }
                }
            }
        }
    }
}

extension TrackRow where Icon == Text, Trailing == EmptyView {
    init(
        padSize: CGFloat = ViewConstants.padSize,
        options: TrackOptions = .init(),
        @ViewBuilder content: @escaping (PadPosition, Range<Beats>) -> Content
    ) {
        self.init(
            padSize: padSize,
            options: options,
            content: content,
            icon: { Text("") }, // Workaround since the Spacer is a bit smaller, unfortunately...
            trailing: {}
        )
    }
}


extension TrackRow where Trailing == EmptyView {
    init(
        padSize: CGFloat = ViewConstants.padSize,
        options: TrackOptions = .init(),
        @ViewBuilder content: @escaping (PadPosition, Range<Beats>) -> Content,
        @ViewBuilder icon: @escaping () -> Icon
    ) {
        self.init(
            padSize: padSize,
            options: options,
            content: content,
            icon: icon,
            trailing: {}
        )
    }
}
