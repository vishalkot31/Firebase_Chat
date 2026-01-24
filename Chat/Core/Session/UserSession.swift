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


enum AuthState{
    case loading
    case loggedOut
    case loggedIn
}

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
    //Auth State is decided
    var authState: AuthState = .loading
    
    //whenever model is updated save to userdefaults
    private(set) var user:UserModel?{
        didSet{
            saveUserToDefaults()
        }
    }
    
    init(user: UserModel? = nil) {
        loadUserFromDefaults()
    }
    
    var myUserID: String {
        user?.id ?? ""
    }
    //Save to dfaults
    private func saveUserToDefaults() {
          guard let user else {
              UserDefaults.standard.removeObject(forKey: "currentUser")
              return
          }
          if let data = try? JSONEncoder().encode(user) {
              UserDefaults.standard.set(data, forKey: "currentUser")
          }
      }
        //Save to user defaults
      private func loadUserFromDefaults() {
          guard let data = UserDefaults.standard.data(forKey: "currentUser"),
                let savedUser = try? JSONDecoder().decode(UserModel.self, from: data) else {
              user = nil
              return
          }
          user = savedUser
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
    //First get the current user data beacuse it is based on user value only
    func restoreUserIfNeeded()async {
        let db = Firestore.firestore()
        guard let firebaseUser = Auth.auth().currentUser else { return }
        
        do {
            // Await Firestore document fetch and decode directly into UserModel
            let documentSnapshot = try await db.collection("users")
                                               .document(firebaseUser.uid)
                                               .getDocument()
            
            // Check if document exists
            guard documentSnapshot.exists else { return }
            
            // Decode the document into UserModel
            let userModel = try documentSnapshot.data(as: UserModel.self)

            // Update on main thread for SwiftUI
            await MainActor.run {
                    self.user = userModel
                }
            }
            catch {
                print("Failed to restore user:", error)
            }
       }
}
