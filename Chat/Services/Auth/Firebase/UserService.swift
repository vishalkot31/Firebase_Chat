//
//  FireStoreService.swift
//  Chat
//
//  Created by Vishal Kothari on 31/01/26.
//

import Foundation
import FirebaseFirestore

//This Class deals with saving data to Firestore

//save & fetch image URLs from firestore

protocol UserServiceProtocol {
    func saveProfileImageURL(userId: String, url: String)
    func fetchProfileImageURL(userId: String, completion: @escaping (String?) -> Void)
    func saveUserInfo(_ user: UserModel) async throws
    func getUserInfo(id: String) async throws -> UserModel
}


enum UserServiceError: Error {
    case userNotFound
    case decodingFailed
}


final class FirestoreService:UserServiceProtocol {
    
    private let db = Firestore.firestore()
    
    //save image
    func saveProfileImageURL(userId: String, url: String) {
        db.collection("users").document(userId)
            .setData(["profileImageURL": url], merge: true)
    }
    
    func fetchProfileImageURL(userId: String, completion: @escaping (String?) -> Void) {
        db.collection("users").document(userId)
            .getDocument { snapshot, _ in
                guard let data = snapshot?.data() else { completion(nil); return }
                completion(data["profileImageURL"] as? String)
            }
    }
    
    //Save user modl in firestore database
    func saveUserInfo(_ user: UserModel) async throws {
        try db.collection("users").document(user.id)
            .setData(from: user, merge: true)
    }
    
    //Get user Model from firestore database
    
    func getUserInfo(id: String) async throws -> UserModel {
        let doc = try await db.collection("users")
                            .document(id).getDocument()
        guard doc.exists else {
            throw UserServiceError.userNotFound
        }
        do {
            return try doc.data(as: UserModel.self)
        } catch {
            throw UserServiceError.decodingFailed
        }
    }
}


