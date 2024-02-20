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

extension TrackRow where Trailing == EmptyView {
    init(
        @ViewBuilder content: @escaping (PadPosition, Range<Beats>) -> Content,
        @ViewBuilder icon: @escaping () -> Icon
    ) {
        self.init(content: content, icon: icon, trailing: {})
    }
}
