//
//  AutoScrollCarsoul.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 13/01/26.
//

import SwiftUI
import Combine

struct AutoScrollCarouselView: View {

    let images = ["WeGet", "WeGet", "WeGet"]
    @State private var currentIndex = 0

    // Auto-scroll timer
    private let timer = Timer.publish(
        every: 3,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        VStack(spacing: 30) {
            GeometryReader { geo in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(images.indices, id: \.self) { index in
                            Image(images[index])
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: geo.size.width,
                                    height: geo.size.height
                                )
                                .clipped()
                        }
                    }
                }
                // 👇 paging effect
                .content.offset(x: -CGFloat(currentIndex) * geo.size.width)
                .animation(.easeInOut, value: currentIndex)

                // 👇 manual swipe
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let threshold = geo.size.width / 2
                            if value.translation.width < -threshold {
                                next()
                            } else if value.translation.width > threshold {
                                previous()
                            }
                        }
                )
                // 👇 auto-scroll
                .onReceive(timer) { _ in
                    next()
                }
            }
           // .frame(height: 220)

            // 👇 Dots indicator
            HStack(spacing: 8) {
                ForEach(images.indices, id: \.self) { index in
                    Circle()
                        .fill(
                            index == currentIndex ? .white : .gray.opacity(0.4)
                        )
                        .frame(width: 8, height: 8)
                }
            }
        }
    }

    private func next() {
        currentIndex = (currentIndex + 1) % images.count
    }

    private func previous() {
        currentIndex = max(currentIndex - 1, 0)
    }
}
