//
//  ForGotPwdVM.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 09/01/26.
//

import Foundation
import Combine

@Observable
@MainActor
final class ForGotPwdVM{
    var email:String = ""
    var password:String = ""
    var isLoading = false
    var errorMessage:String?
    
    private var cancellables = Set<AnyCancellable>()
    // MARK: - Forgot Password
    
    var isFormvalid:Bool{
        ValidationUtils.isValidEmail(email)
    }
    
    let service:AuthServiceProtocol
    init(service:AuthServiceProtocol){
        self.service = service
    }
    
    func forgetPassord(router:Router)async{
        isLoading = true
        errorMessage = nil
        defer{
            isLoading = false
        }
        do {
            try await service.forgetPassordPublisher(email: email)
            router.backScreen()
        }
        catch{
            self.errorMessage = error.localizedDescription
        }
       
        
    }
}


