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
    
    let uploadUseCase:saveUserDataProtocol
    init(uploadUseCase:saveUserDataProtocol = ProfileImageSetupUseCase(
            firestore: UserServiceFactory.makeUserService(type: .custom))){
        self.uploadUseCase = uploadUseCase
    }
    
    //Downlaod profielimage url
//    func loadProfile(id:String) {
//        fetchUseCase.executeFetchImage(userId: id) { [weak self] url in
//               self?.profileImageURL = url
//           }
//       }
    
    
    //Upload image and get profile image url to show back
    func uploadImageModelSubmit(routr:Router,sesion:UserSession) async {
//        guard let image = selectedImage else { return }
//        
//        uploadUseCase.executeUploadImage(image: image, session: sesion) { [weak self] result in
//            guard let self else { return }
//            //After Image is loaded profile image url is return
//            Task{@MainActor in
//                switch result {
//                case .success(let url):
//                   self.profileImageURL = url
//               case .failure(let error):
//                   self.errorMessage = error.localizedDescription
//               }
//            }
//        }
    }
    
    //Save data without image
    @MainActor func saveDataToFirebase(router:Router,sesion:UserSession) async{
        let userID = sesion.user?.id ?? ""
        let  userModel = UserModel(id: userID,
                         email: sesion.user?.email ?? "",
                         displayName: sesion.user?.displayName ?? "",
                         isProfileCompleted: true,
                         bio:self.bio, fullName: self.fullName)
        
        do {
            let returned_Model = try await uploadUseCase.excuteSaveModel(model: userModel)
            router.reset()
            sesion.login(returned_Model)
        }
        catch{
            errorMessage = error.localizedDescription
        }
        
    }
}
