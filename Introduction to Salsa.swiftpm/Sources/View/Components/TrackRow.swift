import SwiftUI

struct TrackRow<Content, Icon, Trailing>: View where Content: View, Icon: View, Trailing: View {
    var options: TrackOptions = .init()
    var padSize: CGFloat = 64
    @ViewBuilder var content: (PadPosition, Range<Beats>) -> Content
    @ViewBuilder var icon: () -> Icon
    @ViewBuilder var trailing: () -> Trailing
    
    var body: some View {
        HStack {
            if options.showsIcon {
                icon()
                    .frame(width: padSize, height: padSize)
            }
            let padIndices = (0..<options.padCount).map { i in
                (
                    index: i,
                    position: PadPosition(
                        beatIndex: i / options.padsPerBeat,
                        padInBeat: i % options.padsPerBeat
                    )
                )
            }
            ForEach(padIndices, id: \.position) { (i, position) in
                let beatRange = (Beats(i) / Beats(options.padsPerBeat))..<(Beats(i + 1) / Beats(options.padsPerBeat))
                content(position, beatRange)
            }
            trailing()
        }
    }
}

extension TrackRow where Icon == Text, Trailing == EmptyView {
    init(
        options: TrackOptions = .init(),
        padSize: CGFloat = 64,
        @ViewBuilder content: @escaping (PadPosition, Range<Beats>) -> Content
    ) {
        self.init(
            options: options,
            padSize: padSize,
            content: content,
            icon: { Text("") }, // Workaround since the Spacer is a bit smaller, unfortunately...
            trailing: {}
        )
    }
}


extension TrackRow where Trailing == EmptyView {
    init(
        options: TrackOptions = .init(),
        padSize: CGFloat = 64,
        @ViewBuilder content: @escaping (PadPosition, Range<Beats>) -> Content,
        @ViewBuilder icon: @escaping () -> Icon
    ) {
        self.init(
            options: options,
            padSize: padSize,
            content: content,
            icon: icon,
            trailing: {}
        )
    }
}
