//
//  UploadImageUsecase.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 18/01/26.
//

import Foundation
import UIKit
import FirebaseStorage

//handle Firebase
//Data layer comminciate with firbase storage for uploading image
//Repository intreact witj 

protocol FirebaseImageUploadProtocol{
    func uploadImage(image: UIImage, userId: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class FirebaseUploadImage:FirebaseImageUploadProtocol{
    
    func uploadImage(image: UIImage,userId: String,completion: @escaping (Result<String, any Error>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.6) else { return }
        let ref = Storage.storage().reference().child("profile_images/\(userId).jpg")
       // Step 1: Upload image
        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            //return url
            // ✅ Step 2: Get download URL AFTER upload
            ref.downloadURL { url, error in
                if let url = url {
                    completion(.success(url.absoluteString))
                } else if let error = error {
                        completion(.failure(error))
                    }
                }
        }
      
    }
}


import FirebaseFirestore


//save & fetch image URLs

protocol FireStoreServiceProtocol {
    func saveProfileImageURL(userId: String, url: String)
    func fetchProfileImageURL(userId: String, completion: @escaping (String?) -> Void)
    func saveUserData(model: UserModel,completion: @escaping (Result<UserModel, any Error>)->Void)
}

final class FirestoreService:FireStoreServiceProtocol {
    
    
    private let db = Firestore.firestore()
    
    func saveProfileImageURL(userId: String, url: String) {
        db.collection("users").document(userId)
            .setData(["profileImageURL": url], merge: true)
    }
    
    func fetchProfileImageURL(userId: String, completion: @escaping (String?) -> Void) {
        db.collection("users").document()
            .getDocument { snapshot, _ in
                guard let data = snapshot?.data() else { completion(nil); return }
                completion(data["profileImageURL"] as? String)
            }
    }
    //Save model 
    func saveUserData(model: UserModel,completion: @escaping (Result<UserModel, any Error>)->Void) {
        // Save user info to Firestore
        do {
            try self.db
                .collection("users")
                .document(model.id ?? "")
                .setData(from: model, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(model)) // Return UserModel
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
