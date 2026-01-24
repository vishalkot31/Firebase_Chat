//
//  HomeVM.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 10/01/26.
//

import Foundation
import Observation

@Observable
class HomeVM {
    var errorMessage :String?
    func logout(session:UserSession,router:Router){
        do {
            try FireBaseAuthService.shared.logout()
            //User Clear
            session.logout()
        }
        catch{
            errorMessage = error.localizedDescription
        }
    }
}
