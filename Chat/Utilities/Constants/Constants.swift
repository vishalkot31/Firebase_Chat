//
//  AppFont.swift
//  Chat
//
//  Created by Vishal Kothari on 02/02/26.
//

import Foundation
import SwiftUI

enum Constants{
    
    enum AppFonts{
        // MARK: - Headings
        static let largeTitle = Font.system(size: 25, weight: .bold)
        static let title = Font.system(size: 22, weight: .semibold)

        // MARK: - Body
        static let body = Font.system(size: 16, weight: .regular)
        static let bodyMedium = Font.system(size: 16, weight: .medium)

        // MARK: - Caption
        static let caption = Font.system(size: 12, weight: .regular)
           
        //MARK: - Button
        static let buttonTitle = Font.system(size:22,weight: .bold)
        
        //MARK: - TextField
        static let textFielldText = Font.system(size: 18,weight: .regular)
        
        // MARK: - ChatMessage
        static let chatUserName = Font.system(size: 16, weight: .regular)
        static let chatMessage = Font.system(size: 16, weight: .medium)
    }
    
    enum AuthEndPoint {
        static let LoginEndPoint = "auth/login"
        static let SigninEndPoint = "auth/signup"
        static let LogOutPoint = "auth/logout"
        static let UpdateProfile = "user/complete-profile"
        static let GetUserProfile = "user/profile"
    }
    
    enum HTTPMethod:String{
        case POST
        case GET
        case PUT
        case DELETE
    }
    
    enum StorageAuthkeys {
       static let AccessToken = "accessToken"
       static let RefreshToken = "refreshToken"
    }
    
    enum AuthAPI {
          static let baseURL = "http://127.0.0.1:8000"
      }
}



