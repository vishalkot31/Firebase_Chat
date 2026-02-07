//
//  CreateAccountVM.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 09/01/26.
//

import Foundation
import Observation

enum LoadingState<T> {
    case idle
    case loading
    case success(String)
    case failure(String)
}


@Observable
final class CreateAccountVM {

    var email = ""
    var password = ""

    var isFormValid: Bool {
        ValidationUtils.isValidEmail(email) && !password.isEmpty
    }
    
    var state:LoadingState<String> = .idle
    
    var alert:AppAlert?
    
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
           return false
    }
    
    //Dependency injection
    let authService:AuthServiceProtocol
    init (authService:AuthServiceProtocol){
        self.authService = authService
    }
    //User register
    func register(userSession:UserSession,router:Router)async{
        state = .loading
        do {
            let user = try await authService.registerAsync(
                email: email,
                password: password)
            state = .success("Account created sucessfully")
            alert = AppAlert(title: "Success",
                             message: "Account created successfully")

            router.reset()
            userSession.login(user)
        }
        catch{
            state = .failure(error.localizedDescription)
            alert = AppAlert(title: "Error",
                            message: error.localizedDescription)
        }
    }
}
