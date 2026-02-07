//
//  AuthService.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 09/01/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine


enum AuthServiceError: Error {
    case invalidCredentials
    case userNotFound
    case decodingFailed
}


//Protocol oriented
protocol AuthServiceProtocol {
    //Async and wait
    func login(email: String, password: String)async throws->UserModel
    func registerAsync(email: String, password: String) async throws -> UserModel
    func forgetPassordPublisher(email: String)async throws
}


//View Model will intratc with this class
//Singelton class
final class FireBaseAuthService:AuthServiceProtocol{
    static let shared = FireBaseAuthService()
    private let firestoreService = FirestoreService()
    
    private init() {}
    
    //Login time
    func login(email: String, password: String)async throws->UserModel{
         // 1️⃣ Firebase Auth
        let authResult = try await Auth.auth()
                .signIn(withEmail: email, password: password)
        let user = authResult.user
        // 2️⃣ Fetch Firestore document baed user id this will act as authid
        let model = try await firestoreService.getUserInfo(id: user.uid)
        return model
    }
    
    //with try and await Register user
    @discardableResult func registerAsync(email: String, password: String) async throws -> UserModel {
        // STEP 1: Create Firebase Auth user
        let userResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let fireBaseUser = userResult.user
        // STEP 2: Create your UserModel (domain entity)
        let userModel = UserModel(
            id: fireBaseUser.uid,
            email: fireBaseUser.email ?? "",
            displayName: "User \(fireBaseUser.uid.prefix(5))",
            isProfileCompleted: false
        )
        // STEP 3: Save to Firestore (orchestration!)
        //Save usermodel into firestore
        try await firestoreService.saveUserInfo(userModel)
        //return user model
        return userModel
        
    }

    //Forget Passord
    func forgetPassordPublisher(email: String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    //Logout
    func logout() throws {
        try Auth.auth().signOut()
    }
    
}




//protocol APIServiceProtocol{
//    func ftechUsers() async throws->[UserList]
//}
//
//
//class ApiService:APIServiceProtocol{
//    func ftechUsers() async throws -> [UserList] {
//        guard let url = URL(
//            string: "https://jsonplaceholder.typicode.com/users") else{
//            throw URLError(.badURL)
//            }
//       let (data,response) = try await URLSession.shared.data(from: url)
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else{
//            throw URLError(.badServerResponse)
//        }
//        
//        return try JSONDecoder().decode([UserList].self, from: data)
//    }
//}
