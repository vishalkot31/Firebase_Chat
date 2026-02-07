//
//  AppLoader.swift
//  Chat
//
//  Created by Vishal Kothari on 06/02/26.
//

import Foundation
import SwiftUI

struct AppLoader: View {

    var message: String = "Please wait..."

    var body: some View {
        VStack(alignment: .center,spacing:12) {
            ProgressView()
                .scaleEffect(1.4)

            Text(message)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .shadow(radius: 10)
    }
}


struct LoadingOverlay: ViewModifier {

    let isLoading: Bool
    let message: String

    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()

                AppLoader(message: message)
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}

extension View {
    func loading(_ isLoading: Bool,message: String = "Loading...") -> some View {
        modifier(LoadingOverlay(isLoading: isLoading, message: message))
    }
}
