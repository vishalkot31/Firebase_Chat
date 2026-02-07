//
//  BackendUserService.swift
//  Chat
//
//  Created by Vishal Kothari on 04/02/26.
//

import Foundation


class BackendUserService:UserServiceProtocol{
    
    let service = BackendApiClient.shared
    
    func saveProfileImageURL(userId: String, url: String) {
        
    }

    func fetchProfileImageURL(userId: String,completion: @escaping (String?) -> Void) {
        
    }

    func saveUserInfo(_ user: UserModel) async throws {
        //Body Request
        let body = UpdateProfileRequest(name: user.fullName,
                                        bio: user.bio,userName: user.displayName,is_profile_complete: true)
       let data = try await service.request(
                endPoint: Constants.AuthEndPoint.UpdateProfile,
                method: .PUT,
                body: body,
                requiresAuth: true)
        
        do {
            let model = try JSONDecoder().decode(UpdatProfileResponseDTO.self,from: data)
            UserModel(id: model.id,
                      email: model.email,
                      displayName: model.username,
                      isProfileCompleted: model.isProfileCompleted,
                      fullName:model.name)
            }
        catch{
            throw NetworkError.decodingError(error)
        }
        
    }

    func getUserInfo(id: String) async throws -> UserModel {
        let data = try await service.request(
            endPoint: Constants.AuthEndPoint.GetUserProfile,
            method: .GET,requiresAuth: true)
        do {
            let model = try JSONDecoder().decode(UpdatProfileResponseDTO.self,from: data)
            return UserModel(id: model.id,
                      email: model.email,
                      displayName: model.username,
                      isProfileCompleted: model.isProfileCompleted,
                      fullName:model.name)
            }
        catch{
            throw NetworkError.decodingError(error)
        }
    }

    
}
