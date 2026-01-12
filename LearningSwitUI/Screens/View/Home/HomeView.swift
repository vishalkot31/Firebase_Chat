//
//  HomeView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 09/01/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(UserSession.self) private var session
    @Environment(Router.self) private var router
    @State private var vm = HomeVM()
    
    var body: some View {
        VStack(spacing: 20) {
                // Profile Info
            if let user = session.user {
                VStack(spacing: 8) {
                    Text(user.displayName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(session.user?.email ?? "")
                        .foregroundStyle(.secondary)
                        }
                    } else {
                        ProgressView("Loading profile...")
                    }

                    Spacer()

                    // Logout Button
                    Button(role: .destructive) {
                        vm.logout(session: session, router: router)
                    } label: {
                        Text("Logout")
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .navigationTitle("Profile")
                .navigationBarBackButtonHidden(true)
            }
    
}

#Preview {
    HomeView().environment(Router()).environment(UserSession())
}
