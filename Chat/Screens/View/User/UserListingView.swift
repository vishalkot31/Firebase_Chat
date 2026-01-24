//
//  UserListing.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 15/01/26.
//

import SwiftUI

struct UserListingView: View {
    @Environment(Router.self) private var router
    @Environment(UserSession.self) private var session
    private var viewModel = UserListVM()
    var body: some View {
        content.onAppear{
            print("vishal")
        }
        .navigationTitle("UserList")
        .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchUserList(session: session)
            }
    }
    
    @ViewBuilder  private var content:some View{
        if viewModel.isLoading{
            ProgressView("Loading...")
        }
        else if let error = viewModel.errorMessage{
            VStack{
                Text(error)
                    .foregroundStyle(.red)
                Button("Retry"){
                    Task{
                        await viewModel.fetchUserList(session: session)
                    }
                }
            }
        }
        else{
            List(viewModel.userList){
                user in
                UserRowView(user: user) {
                    //on tap
                    router.pushApp(destination: .chatView(otherUserModel:user))
                }
            }.listStyle(.plain)
            
        }
    }
}

#Preview {
    UserListingView().environment(Router()).environment(UserSession())
}

//User Row
struct UserRowView:View {
    let user:UserModel
    let onTap:()->Void
    
    var body: some View{
        VStack(alignment: .leading,spacing: 5){
            Text(user.fullName)
                .font(.title2)
            Text(user.email)
                .font(.subheadline)
        }.onTapGesture {
            onTap()
        }
    }
}
