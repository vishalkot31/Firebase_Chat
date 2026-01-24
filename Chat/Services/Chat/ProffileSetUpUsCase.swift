//
//  ProffileSetUpUsCase.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 18/01/26.
//

import Foundation
import UIKit

// Use case for uploading image and then image url
protocol UploadProfileImageUseCaseProtocol {
    func execute(image: UIImage, userId: String, completion: @escaping (Result<String, Error>) -> Void)
    func excute(model: UserModel,completion: @escaping (Result<UserModel, any Error>) -> Void)
}

// Use case for fetching image
protocol FetchProfileImageUseCaseProtocol {
    func execute(userId: String, completion: @escaping (String?) -> Void)
}


class ProfileImageSetupUseCase:UploadProfileImageUseCaseProtocol,FetchProfileImageUseCaseProtocol{

    private let storage: FirebaseImageUploadProtocol
    private let firestore: FireStoreServiceProtocol
    
    init(storage: FirebaseImageUploadProtocol = FirebaseUploadImage(),
        firestore: FireStoreServiceProtocol = FirestoreService()) {
        self.storage = storage
        self.firestore = firestore
    }
    
    //Upload image and then save return url into fireabse store
    func execute(image: UIImage,userId: String,completion: @escaping (Result<String, any Error>) -> Void) {
        storage.uploadImage(image: image, userId: userId) { result in
            switch result{
            case .success( let url):
                self.firestore.saveProfileImageURL(userId: userId, url: url)
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //Ftech the image for user id
    func execute(userId: String, completion: @escaping (String?) -> Void) {
        firestore.fetchProfileImageURL(userId: userId, completion: completion)
    }
    
    func excute(model: UserModel,completion: @escaping (Result<UserModel, any Error>) -> Void
    ) {
        firestore.saveUserData(model: model, completion: completion)
    }

}
