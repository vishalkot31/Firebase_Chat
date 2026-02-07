//
//  BackendServiceType.swift
//  Chat
//
//  Created by Vishal Kothari on 04/02/26.
//

import Foundation

enum BackendType: String {
    case firebase
    case custom
}


struct AuthServiceFactory {
    
    static func makeAuthService(type:BackendType)->AuthServiceProtocol{
        switch type{
        case .firebase:
            return FireBaseAuthService.shared
        case .custom:
            return BackendAuthService()
        }
    }
    
}

struct UserServiceFactory{
    static func makeUserService(type:BackendType)->UserServiceProtocol{
        switch type{
        case .firebase:
            return FirestoreService()
        case .custom:
            return BackendUserService()
        }
    }
}
