//
//  ProffileSetUpUsCase.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 18/01/26.
//

import Foundation
import UIKit

//// Use case for uploading image and then image url
//protocol UploadProfileImageUseCaseProtocol {
//    func executeUploadImage(image: UIImage,session:UserSession, completion: @escaping (Result<String, any Error>) -> Void)
//
//}
//
//// Use case for fetching image
//protocol FetchProfileImageUseCaseProtocol {
//    func executeFetchImage(userId: String, completion: @escaping (String?) -> Void)
//}

protocol saveUserDataProtocol{
    func excuteSaveModel(model: UserModel) async throws -> UserModel
}

class ProfileImageSetupUseCase:saveUserDataProtocol{

    private let firestore: UserServiceProtocol
    
    init(firestore: UserServiceProtocol) {
        self.firestore = firestore
    }
    
//    //Upload image and then save return url into fireabse store
//    func executeUploadImage(image: UIImage,session:UserSession, completion: @escaping (Result<String, any Error>) -> Void) {
//        let id  = session.myUserID
//        storage.uploadImage(image: image, userId: id) { result in
//            switch result{
//            case .success( let url):
//                //Save image in firestore database
//                self.firestore.saveProfileImageURL(userId: id, url: url)
//                //return the image url
//                completion(.success(url))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    //Save model data to database and return data
     func excuteSaveModel(model: UserModel) async throws -> UserModel {
        try await firestore.saveUserInfo(model)
        return try await firestore.getUserInfo(id: model.id)
    }
    
//    //Fetch the image for user id
//    func executeFetchImage(userId: String, completion: @escaping (String?) -> Void) {
//        firestore.fetchProfileImageURL(userId: userId, completion: completion)
//    }
    

}

