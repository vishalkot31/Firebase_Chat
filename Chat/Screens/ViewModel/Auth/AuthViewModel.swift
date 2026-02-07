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
    var showError = false
    
    var isFormvalid:Bool{
        ValidationUtils.isValidEmail(email) && !password.isEmpty
    }
    
    
    //Dependency injection
    let authService:AuthServiceProtocol
    init (authService:AuthServiceProtocol){
        self.authService =  authService
    }
    
    //User Login
    @MainActor
    func login(router:Router,session:UserSession) async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        
        do {
            let model = try await authService.login(email: email, password: password)
            session.login(model)
        }
        catch (let failure) {
            self.showError = true
            self.errorMessage = failure.localizedDescription
        }
        
    }
    
}
