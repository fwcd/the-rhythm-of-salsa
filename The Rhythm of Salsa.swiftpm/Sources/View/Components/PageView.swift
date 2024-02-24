import SwiftUI

struct PageView<Detail, Navigation, Background>: View
    where Detail: View,
          Navigation: View,
          Background: View {
    let title: String
    let text: String
    var isCentered: Bool = true
    var alwaysVertical: Bool = false
    @ViewBuilder let detail: () -> Detail
    @ViewBuilder let navigation: () -> Navigation
    @ViewBuilder let background: (Bool) -> Background
    
    var body: some View {
        GeometryReader { geometry in
            let usesCompactTitle = geometry.size.height < ViewConstants.verticalBreakpoint
            VStack(spacing: ViewConstants.veryLargeSpace) {
                VStack(spacing: ViewConstants.mediumSpace) {
                    if !usesCompactTitle {
                        Text(title)
                            .font(.system(size: ViewConstants.titleFontSize))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    Text(text)
                        .multilineTextAlignment(.center)
                        .font(.system(size: ViewConstants.subtitleFontSize))
                        .frame(maxWidth: 400)
                    HStack {
                        navigation()
                    }
                }
                detail()
            }
            .navigationTitle(Text(usesCompactTitle ? title : ""))
            .padding(ViewConstants.smallSpace)
            .frame(
                width: geometry.frame(in: .global).width,
                height: geometry.frame(in: .global).height,
                alignment: isCentered ? .center : .top
            )
            .background {
                background(usesCompactTitle)
            }
        }
    }
}

extension PageView where Background == EmptyView {
    init(
        title: String,
        text: String,
        @ViewBuilder detail: @escaping () -> Detail,
        @ViewBuilder navigation: @escaping () -> Navigation
    ) {
        self.init(
            title: title,
            text: text,
            detail: detail,
            navigation: navigation,
            background: { _ in }
        )
    }
}

extension PageView where Navigation == EmptyView, Background == EmptyView {
    init(title: String, text: String, @ViewBuilder detail: @escaping () -> Detail) {
        self.init(
            title: title,
            text: text,
            detail: detail,
            navigation: {},
            background: { _ in }
        )
    }
}


extension PageView where Detail == EmptyView, Navigation == EmptyView, Background == EmptyView {
    init(title: String, text: String) {
        self.init(
            title: title,
            text: text,
            detail: {},
            navigation: {},
            background: { _ in }
        )
    }
}
