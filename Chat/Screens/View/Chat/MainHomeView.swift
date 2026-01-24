//
//  MainHomeView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 21/01/26.
//

import SwiftUI
struct MainHomeView: View {
    @Environment(Router.self) private var router
    @Environment(UserSession.self) private var session

    var body: some View {
            VStack(spacing: 20) {
                // Welcome header
                Text("Welcome, \(session.user?.email ?? "User")")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)

                // Active Chats
                
                ChatListView()
                Spacer()
                // Start New Chat button
                Button(action: {
                    router.pushApp(destination: .UserList)
                }) {
                    Text("Start New Chat")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal,24)
                }

        }.navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MainHomeView().environment(Router()).environment(UserSession())
}
