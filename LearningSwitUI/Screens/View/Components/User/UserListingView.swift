//
//  UserListing.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 15/01/26.
//

import SwiftUI

struct UserListingView: View {
    @Environment(Router.self) private var router
    @State private var viewModel = UserListVM()
    var body: some View {
        content
        .navigationTitle("UserList")
            .task {
                await viewModel.fetchUserList()
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
                        await viewModel.fetchUserList()
                        }
                    
                    }
                }
            }
            else{
                List(viewModel.userList){
                    user in
                    UserRowView(user: user) {
                        router.pushApp(destination: .userDetail(id: user.id))
                    }
                }
            }
        }
}

#Preview {
    UserListingView().environment(Router())
}

//User Row
struct UserRowView:View {
    let user:UserList
    let onTap:()->Void
    
    var body: some View{
        VStack(alignment: .leading,spacing: 20){
            Text(user.name)
                .font(.largeTitle)
            Text(user.email)
                .font(.subheadline)
        }.onTapGesture {
            onTap()
        }
    }
}
