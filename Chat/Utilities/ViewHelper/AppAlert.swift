//
//  AppAlert.swift
//  Chat
//
//  Created by Vishal Kothari on 06/02/26.
//

import Foundation
import SwiftUI

struct AppAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryButton: Alert.Button
    let secondaryButton: Alert.Button?

    init(
        title: String,
        message: String,
        primaryButton: Alert.Button = .default(Text("OK")),
        secondaryButton: Alert.Button? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}


struct AppAlertView: View {

    let title: String
    let message: String
    let primaryTitle: String
    let primaryAction: () -> Void
    let secondaryTitle: String?
    let secondaryAction: (() -> Void)?

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text(title)
                    .font(.title3.bold())

                Text(message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                HStack {
                    if let secondaryTitle {
                        Button(secondaryTitle) {
                            secondaryAction?()
                        }
                        .foregroundStyle(.red)
                    }

                    Spacer()

                    Button(primaryTitle) {
                        primaryAction()
                    }
                    .fontWeight(.semibold)
                }
            }
            .padding(24)
            .background(.background)
            .cornerRadius(20)
            .shadow(radius: 30)
            .frame(maxWidth: 320)
        }
    }
}

struct AppAlertModifier: ViewModifier {

    @Binding var alert: AppAlert?
    func body(content: Content) -> some View {
         ZStack {
             content
             if let alert {
                 AppAlertView(title: alert.title,
                              message: alert.message,
                              primaryTitle: "OK",
                              primaryAction: {
                                self.alert = nil
                            },
                              secondaryTitle: nil,
                              secondaryAction: nil
                 )
             }
         }
     }
}

extension View {
    func appAlert(_ alert: Binding<AppAlert?>) -> some View {
        modifier(AppAlertModifier(alert: alert))
    }
}
