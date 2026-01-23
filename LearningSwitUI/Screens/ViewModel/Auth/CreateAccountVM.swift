//
//  CreateAccountVM.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 09/01/26.
//

import Foundation
import Observation
@Observable
final class CreateAccountVM {

    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?

    var isFormValid: Bool {
        ValidationUtils.isValidEmail(email) && !password.isEmpty
    }

    //User register
    func register(userSession:UserSession,router:Router)async{
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false // always reset loading state
        }
        do {
            let user = try await FireBaseAuthService.shared.registerAsync(email: email, password: password)
            userSession.login(user)
            router.reset()
            
        }
        catch{
            errorMessage = error.localizedDescription
        }
    }
}
