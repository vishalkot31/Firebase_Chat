//
//  UserSession.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 10/01/26.
//

import Foundation
import Observation

@Observable
final class UserSession{
    private(set) var user:UserModel?
    
    var isLoggedIn: Bool {
        user != nil
    }

    func setUser(_ user: UserModel) {
        self.user = user
    }

    func clear() {
        user = nil
    }
}
