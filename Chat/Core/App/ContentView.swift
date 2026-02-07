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
   
    @State private var router = Router()
    //Untill use is restored ecuase auth is decide based on user data
    @AppStorage("hasSeenGetStarted") private var hasSeenGetStarted: Bool = false
    @State private var isRestoringUser = true
    @Environment(UserSession.self) private var session
    var body: some View {
            Group {
                // First-time user whic has not get to started view
                if !hasSeenGetStarted {
                    GetStartedView{
                        hasSeenGetStarted = true
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
                try? await Task.sleep(for: .milliseconds(100))
                isRestoringUser = false
            }
        .environment(router)
    }
    
    
    //Set the app flow baesd on auth
    private var mainAppFlowView:some View{
        NavigationStack(path:$router.path){
            
            rootViewDecider //Two routes app auth flow and chat flow after login
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

//Decide the app the root Flow on starting which scrren to show
// This view based on session flow value

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
    case .userDetail(let id):
        UserDetailView(userId: id)
    case .completeProfile:
        ProfileSetupView()
    case .chatList:
        ChatListView()
    case .chatView(let id,let otherName):
        ChatView(otherId: id, otherName: otherName)
    }
}

#Preview {
    ContentView().environment(Router())
}
