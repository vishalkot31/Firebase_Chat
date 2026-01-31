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

//Retuen url where file is upladed
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


