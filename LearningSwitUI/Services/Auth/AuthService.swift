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

//Protocol oriented
protocol AuthServiceProtocol {
    //Async and wait
    var currentUser: User? { get }
    func login(email: String,password: String,completion: @escaping (Result<UserModel, Error>) -> Void)
    func registerAsync(email: String, password: String) async throws -> UserModel
    func forgetPassordPublisher(email: String) ->AnyPublisher<Void,Error>
    func logout() throws
    
//    //combine Version
//    
//    func loginPublisher(email:String,password:String)->AnyPublisher<User,Error>
//    func registerPublisher(email:String,password:String)->AnyPublisher<User,Error>
//    func forgetPassordPublisher(email:String)->AnyPublisher<Void,Error>
}


//View Model will intratc with this class
//Singelton class
final class FireBaseAuthService:AuthServiceProtocol{
    
    static let shared = FireBaseAuthService()
    private let db = Firestore.firestore()
    
    private init() {}
    var currentUser: User?{
        Auth.auth().currentUser
    }
    
    //Login time
    func login(email: String,password: String,completion: @escaping (Result<UserModel, any Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password){result,error in
            if let error = error{
                completion(.failure(error))
            }
            else if let user = result?.user{
                //Create user model
                let userModel = UserModel(id: user.uid,email: user.email ?? "",displayName: "User \(user.uid.prefix(5))")
    
                // Save user info to Firestore
                do {
                    try self.db.collection("users").document(user.uid).setData(from: userModel, merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(userModel)) // Return UserModel
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    //with try and await Register user
    @discardableResult  func registerAsync(email: String, password: String) async throws -> UserModel {
        let userResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let fireBaseUser = userResult.user
        //Prepare user Model
        
        let UserModel = UserModel(id: fireBaseUser.uid,email: fireBaseUser.email ?? "",displayName: "User \(fireBaseUser.uid.prefix(5))")
        
        //Save usermodel into database
        
        try await db.collection("users").document(fireBaseUser.uid).setData(from: UserModel,merge: true)
        //return user model
        return UserModel
        
    }

    //Forget Passord
    func forgetPassordPublisher(email: String) ->AnyPublisher<Void,Error> {
        return Future<Void,Error>{promise in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    promise(.failure(error))
                    
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
        
    }
    
    //Logout
    func logout() throws {
        try Auth.auth().signOut()
    }
    
}


protocol APIServiceProtocol{
    func ftechUsers() async throws->[UserList]
}


class ApiService:APIServiceProtocol{
    func ftechUsers() async throws -> [UserList] {
        guard let url = URL(
            string: "https://jsonplaceholder.typicode.com/users") else{
            throw URLError(.badURL)
            }
       let (data,response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else{
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([UserList].self, from: data)
    }
}
