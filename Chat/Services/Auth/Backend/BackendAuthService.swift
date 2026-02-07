//
//  BackendAuthService.swift
//  Chat
//
//  Created by Vishal Kothari on 03/02/26.
//

import Foundation
import Combine


class BackendAuthService:AuthServiceProtocol{
    
    let service = BackendApiClient.shared
    
    func login(email: String, password: String) async throws -> UserModel {
        //Make Request
        let body = LoginRequestDTO(email: email, password: password)
        let data = try await service.request(
            endPoint: Constants.AuthEndPoint.LoginEndPoint,
            body: body,
            requiresAuth: false
        )
        do {
            let dto = try JSONDecoder().decode(SignUpAPIUserDTO.self, from: data)
            SessionStore.shared.accessToken = dto.accessToken
            return UserModel(api: dto)
        }
        catch{
            throw NetworkError.decodingError(error)
        }
       
    }

    func registerAsync(email: String, password: String) async throws -> UserModel {
        let body = LoginRequestDTO(email: email, password: password)
        
        let data = try await service.request(endPoint: Constants.AuthEndPoint.SigninEndPoint,body: body,requiresAuth: false)
        do {
            let dto = try JSONDecoder().decode(SignUpAPIUserDTO.self, from: data)
            SessionStore.shared.accessToken = dto.accessToken
            return UserModel(api: dto)
        }
        catch{
            throw NetworkError.decodingError(error)
        }
    }

    func forgetPassordPublisher(email: String)async throws{
        
    }

    func logout()async throws {
        let data = try await service.request(endPoint: Constants.AuthEndPoint.LogOutPoint,requiresAuth: true)
        let model = try JSONDecoder().decode(LogOutDTO.self, from: data)
    }
    
}
