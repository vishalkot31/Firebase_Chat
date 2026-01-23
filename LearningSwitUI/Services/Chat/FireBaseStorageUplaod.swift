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

protocol FirebaseImageUploadProtocol{
    func uploadImage(image: UIImage, userId: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class FirebaseUploadImage:FirebaseImageUploadProtocol{
    
    func uploadImage(image: UIImage,userId: String,completion: @escaping (Result<String, any Error>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.6) else { return }
        let ref = Storage.storage().reference().child("profile_images/\(userId).jpg")
        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
        }
        //return url
        ref.downloadURL { url, error in
            if let url = url {
                completion(.success(url.absoluteString))
            } else if let error = error {
                    completion(.failure(error))
                }
            }
    }
}


import FirebaseFirestore


//save & fetch image URLs

protocol FireStoreServiceProtocol {
    func saveProfileImageURL(userId: String, url: String)
    func fetchProfileImageURL(userId: String, completion: @escaping (String?) -> Void)
}

final class FirestoreService:FireStoreServiceProtocol {
    
    func saveProfileImageURL(userId: String, url: String) {
        Firestore.firestore().collection("users").document(userId)
            .setData(["profileImageURL": url], merge: true)
    }
    
    func fetchProfileImageURL(userId: String, completion: @escaping (String?) -> Void) {
        Firestore.firestore().collection("users").document(userId)
            .getDocument { snapshot, _ in
                guard let data = snapshot?.data() else { completion(nil); return }
                completion(data["profileImageURL"] as? String)
            }
    }
}
