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
    
    func foregetPassord(router:Router){
        isLoading = true
        errorMessage = nil
        FireBaseAuthService.shared.forgetPassordPublisher(email: email)
            .sink { [weak self] completion in
                guard let self = self else{
                    return
                }
                self.isLoading = false
                switch completion{
                case .finished:
                    router.backScreen()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: {
                // Nothing to handle, Void type
            }.store(in: &cancellables)
        
    }
}
