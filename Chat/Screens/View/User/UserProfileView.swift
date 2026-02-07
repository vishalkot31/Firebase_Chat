//
//  HomeView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 09/01/26.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(UserSession.self) private var session
    @Environment(Router.self) private var router
    @State private var vm = HomeVM()
    
    var body: some View {
        VStack(spacing: 20) {
                // Profile Info
            if let user = session.user {
                VStack(alignment:.leading, spacing: 8) {
                    Text("Contact Information")
                        .font(Constants.AppFonts.largeTitle)
                    VStack{
                        Text(user.displayName)
                            .font(Constants.AppFonts.title)
                        Text(session.user?.email ?? "")
                            .foregroundStyle(.secondary)
                            .font(Constants.AppFonts.bodyMedium)
                    }.padding(.leading)
                    
                    Divider()
                    }
                }
            else {
                ProgressView("Loading profile...")
                }

                Spacer()
                // Logout Button action
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
                .navigationBarBackButtonHidden(false)
            }
}

#Preview {
    UserProfileView().environment(Router()).environment(UserSession())
}
