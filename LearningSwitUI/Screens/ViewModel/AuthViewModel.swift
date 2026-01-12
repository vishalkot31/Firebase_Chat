//
//  Untitled.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 09/01/26.
//

import Observation
import SwiftUI

@Observable

final class AuthViewModel{
    var email:String = ""
    var password:String = ""
    var isLoading = false
    var errorMessage:String?
    
    var isFormvalid:Bool{
        ValidationUtils.isValidEmail(email) && !password.isEmpty
    }
    
    //User Login
    @MainActor
    func login(router:Router,session:UserSession){
        isLoading = true
        errorMessage = nil
        FireBaseAuthService.shared
            .login(email: email, password: password) { [weak self] result in
                DispatchQueue.main.async{
                    self?.isLoading = false
                    switch result{
                    case .success(let model):
                        session.setUser(model)
                        router.loginSuccess()
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
    }
    
}
