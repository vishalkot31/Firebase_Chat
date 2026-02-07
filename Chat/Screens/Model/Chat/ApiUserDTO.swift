//
//  ApiUserDTO.swift
//  Chat
//
//  Created by Vishal Kothari on 03/02/26.
//

import Foundation


//MARK: - Request Format
struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}
struct UpdateProfileRequest:Encodable{
    let name:String
    let bio:String?
    let userName:String?
    let is_profile_complete:Bool
}

//MARK: - Response Format

struct SignUpAPIUserDTO: Codable {
    let id: Int
    let email: String
    let isProfileCompleted: Bool
    let accessToken: String
    let tokenType:String

    enum CodingKeys: String, CodingKey {
        case id, email
        case isProfileCompleted = "isProfileComplete"
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

struct UpdatProfileResponseDTO:Codable{
    let id: String
    let email:String
    let name: String
    let username: String
    let bio: String?
    let isProfileCompleted: Bool
}

struct LogOutDTO:Codable{
    let msg:String
    enum CodingKeys:String,CodingKey{
        case msg = "message"
    }
}
