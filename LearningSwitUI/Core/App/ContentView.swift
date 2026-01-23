//
//  ContentView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 02/01/26.
//

import SwiftUI
import Observation

//Root View Conatins only one stack view
//Checking

struct ContentView: View {
    @AppStorage("hasSeenGetStarted") private var hasSeenGetStarted: Bool = false
    @AppStorage("userData") private var userData: Data?
    @State private var router = Router()
    @State private var session = UserSession()
    var body: some View {
            Group {
                //Setup root View which is decide based on condition
                if hasSeenGetStarted{
                    //decide root view based on auth
                    appFlow
                }
                else{
                    GetStartedView{
                        hasSeenGetStarted = true
                        session.logout()
                    }
                }
            }.onAppear(){
                if let data = userData,
                   let saveduser =  try? JSONDecoder().decode(UserModel.self, from: data){
                    session.login(saveduser)
                }
                else{
                    session.restoreUserIfNeeded()
                }
            }
        .environment(router)
        .environment(session)
            
    }
    
    //Set the app flow baesd on auth
    private var appFlow:some View{
        NavigationStack(path:$router.path){
            rootView
            //Two routes
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
    var rootView: some View {
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
