//
//  UserSession.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 10/01/26.
//

import Foundation
import Observation
import FirebaseAuth
import FirebaseFirestore

//UserSession is your single source of truth for user/auth stateor global state
enum AppRootFlow {
   // case launching
    case login
    case setupProfile
    case main
}

//User App Sate decide the root view
@Observable
final class UserSession{
    private(set) var user:UserModel?{
        didSet{
            saveUserToDefaults()
        }
    }
    
    init(user: UserModel? = nil) {
        loadUserFromDefaults()
    }
    
    private func saveUserToDefaults() {
          guard let user else {
              UserDefaults.standard.removeObject(forKey: "currentUser")
              return
          }
          if let data = try? JSONEncoder().encode(user) {
              UserDefaults.standard.set(data, forKey: "currentUser")
          }
      }

      private func loadUserFromDefaults() {
          guard let data = UserDefaults.standard.data(forKey: "currentUser"),
                let savedUser = try? JSONDecoder().decode(UserModel.self, from: data) else {
              user = nil
              return
          }
          user = savedUser
      }
    
    var myUserID: String {
        user?.id ?? ""
    }
    
    var isLoggedIn: Bool {
        user != nil
    }
    
    //Flow will deice on this base
    //if suer is nill move to login screen
    var flow:AppRootFlow{
        guard let user else{
            return .login
        }
        return user.isProfileCompleted ? .main : .setupProfile
    }

    //Update user automatically call flow
    func login(_ user: UserModel) {
        self.user = user
    }

    func logout() {
        user = nil
    }
    
    // Restore user if already logged in
    func restoreUserIfNeeded() {
        
        guard let firebaseUser = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        db.collection("users").document(firebaseUser.uid).getDocument { snapshot, error in
            guard let snapshot, snapshot.exists else { return }

            Task { @MainActor in
                do {
                    let userModel = try snapshot.data(as: UserModel.self)
                    self.user = userModel
                } catch {
                    print("Failed to decode user:", error)
                }
               }
           }
       }
}
