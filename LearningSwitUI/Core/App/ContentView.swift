//
//  ContentView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 02/01/26.
//

import SwiftUI
import Observation

//Root View Conatins only one stack view
//

struct ContentView: View {
    @State private var router = Router()
    @State private var userModel = UserSession()
    var body: some View {
        NavigationStack(path:$router.path){
            SignInView()
                .navigationDestination(for: AuthFlow.self) { route in
                    destinationView(for: route)
                }
                .navigationDestination(for: AppFlow.self) { route in
                    appDestinationView(for: route)
                }
        }.environment(router)
            .environment(userModel)
    }
}
    
@ViewBuilder
func destinationView(for route: AuthFlow) -> some View {
    switch route {
    case .createAccount:
        CreateAccountView()

    case .forgetPassord:
        ForgetPwd()
    }
}

@ViewBuilder
func appDestinationView(for route: AppFlow) -> some View {
    switch route {
    case .home:
        HomeView()
    }
}

#Preview {
    ContentView()
}
