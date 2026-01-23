//
//  ProfileSetUpVM.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 18/01/26.
//

import Foundation
import Observation
import UIKit


@Observable
@MainActor
class ProfileSetUpVM{
    
  var userNanme:String = ""
  var fullName:String = ""
  var bio = ""
  var profileImageURL: String?
  var selectedImage: UIImage?
    
  var errorMessage: String?
    var isvalidToGo:Bool {
        return selectedImage != nil && !fullName.isEmpty
    }
    
    private let fetchUseCase: FetchProfileImageUseCaseProtocol
    private let uploadUseCase: UploadProfileImageUseCaseProtocol
    
    init(fetchUseCase: FetchProfileImageUseCaseProtocol = ProfileImageSetupUseCase(),
        uploadUseCase: UploadProfileImageUseCaseProtocol = ProfileImageSetupUseCase()) {
        self.fetchUseCase = fetchUseCase
        self.uploadUseCase = uploadUseCase
    }
    
    
    //Downlaod profielimage url
    func loadProfile(id:String) {
        fetchUseCase.execute(userId: id) { [weak self] url in
               self?.profileImageURL = url
           }
       }
    
    
    //Upload image and get profile image url
    func uploadImageModelSubmit(routr:Router,sesion:UserSession) {
        guard let image = selectedImage else { return }
        var userID = sesion.user?.id ?? ""
        uploadUseCase
            .execute(image: image, userId: userID) { [weak self] result in
                guard let self else { return }
               switch result {
               case .success(let url):
                   self.profileImageURL = url
                   //Create Model
                   
                   let  user = UserModel(
                    id: userID,
                    email: sesion.user?.email ?? "",
                    displayName: sesion.user?.displayName ?? "",
                    isProfileCompleted: true,
                    bio:self.bio, fullName: self.fullName)
                   //Update databse too
                   uploadUseCase.excute(model: user) { result in
                       switch result{
                           
                       case .success(let model):
                           sesion.login(model)
                           routr.pushApp(destination: .chatList)
                       case .failure(let error):
                           self.errorMessage = error.localizedDescription
                       }
                   }
                  
               case .failure(let error):
                   self.errorMessage = error.localizedDescription
               }
           }
       }
    //Save data without image
    
    func saveData(router:Router,sesion:UserSession){
        let userID = sesion.user?.id ?? ""
        let  user = UserModel(
         id: userID,
         email: sesion.user?.email ?? "",
         displayName: sesion.user?.displayName ?? "",
         isProfileCompleted: true,
         bio:self.bio, fullName: self.fullName)
        
        uploadUseCase.excute(model: user) { result in
            switch result{
            case .success(let model):
                sesion.login(model)
                router.pushApp(destination: .chatList)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
        
    }
}
