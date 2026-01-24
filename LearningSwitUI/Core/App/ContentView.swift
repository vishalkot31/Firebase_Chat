//
//  ContentView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 02/01/26.
//

import SwiftUI
import Observation

//Root View Conatins only one stack view

struct ContentView: View {
    @AppStorage("hasSeenGetStarted") private var hasSeenGetStarted: Bool = false
    @AppStorage("userData") private var userData: Data?
    @State private var router = Router()
    @State private var session = UserSession()
    //Untill use is restored ecuase auth is decide based on user data
    @State private var isRestoringUser = true
    
    var body: some View {
            Group {
                // First-time user
                if !hasSeenGetStarted {
                    GetStartedView{
                        hasSeenGetStarted = true
                        session.logout()
                    }
                }
                else if  isRestoringUser {
                    // Placeholder while restoring user
                    VStack {
                        ProgressView("Restoring session...")
                                    .progressViewStyle(CircularProgressViewStyle())
                        Text("Please wait")
                                .font(.footnote)
                                .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else{
                    // Main app flow after user is restored
                    mainAppFlowView
                }
            }
            .task {
                // 1️⃣ Try restoring from local storage first
                if let data = userData,
                    let saveduser =  try? JSONDecoder().decode(UserModel.self, from: data){
                    session.login(saveduser)
                }
                else{
                    // 2️⃣ If no local data, restore asynchronously from Firestore
                    await session.restoreUserIfNeeded()
                }
                isRestoringUser = false
            }
            
        .environment(router)
        .environment(session)
            
    }
    
    
    //Set the app flow baesd on auth
    private var mainAppFlowView:some View{
        NavigationStack(path:$router.path){
            
            rootViewDecider //Two routes app auth flow and caht flow
                .navigationDestination(for: AppAuthFlow.self) { route in
                    //Which view
                authDestinationView(for: route)
            }
            .navigationDestination(for: AppRouteFlow.self) { route in
                appDestinationView(for: route)
            }
        }
    }
}

//Decide the app the root Flow on staring whic scrren to show
//decideinf root view based on session flow value

extension ContentView {

    @ViewBuilder
    var rootViewDecider: some View {
        //It os based on computed property of flow retuen enum based on that view is return
        switch session.flow {
        case .login:
            SignInView()
        case .setupProfile:
            ProfileSetupView()
        case .main:
            MainHomeView()
        }
    }
}
   
//this is for auth navigation router
@ViewBuilder
func authDestinationView(for route: AppAuthFlow) -> some View {
    switch route {
    case .createAccount:
        CreateAccountView()

    case .forgetPassord:
        ForgetPwd()
    }
}

//this is for after login inside aspp
@ViewBuilder
func appDestinationView(for route: AppRouteFlow) -> some View {
    switch route {
    case .userProfile:
        UserProfileView()
    case .UserList:
        UserListingView()
    case .userDetail(id: let id):
        UserDetailView(userId: id)
    case .completeProfile:
        ProfileSetupView()
    case .chatList:
        ChatListView()
    case .chatView(let otherUserID):
        ChatView(otherUserModel: otherUserID)
    }
}

#Preview {
    ContentView()
}
