//
//  Untitled.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/05/2025.
//

import SwiftUI

struct PortraitLockedView<Content: View>: View {
    let content: Content
    @State private var isLandscape = false

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            let isLandscapeNow = geometry.size.width > geometry.size.height
            content
                .rotationEffect(Angle(degrees: isLandscapeNow ? -90 : 0))
                .frame(
                    width: isLandscapeNow ? geometry.size.height : geometry.size.width,
                    height: isLandscapeNow ? geometry.size.width : geometry.size.height
                )
                .offset(x: isLandscapeNow ? (geometry.size.width - geometry.size.height) / 2 : 0,
                        y: isLandscapeNow ? (geometry.size.height - geometry.size.width) / 2 : 0)
                .animation(.easeInOut(duration: 0.3), value: isLandscapeNow)
        }
        .ignoresSafeArea()
    }
}
