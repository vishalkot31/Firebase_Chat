//
//  AuthSeesionStore.swift
//  Chat
//
//  Created by Vishal Kothari on 04/02/26.
//

import Foundation


class SessionStore{
    static let shared = SessionStore()
    private init(){}
    
    //Returning access token
    var accessToken:String? {
        get{
            return try? KeychainWrapper.shared
                .readString(for: Constants.StorageAuthkeys.AccessToken)
        }
        
        set {
            if let value = newValue{
                try? KeychainWrapper.shared.saveString(value, for:  Constants.StorageAuthkeys.AccessToken)
            }
            else{
                KeychainWrapper.shared.delete(for: Constants.StorageAuthkeys.AccessToken)
            }
        }
      
    }
    
    var refreshToken: String? {
          get {
              return try? KeychainWrapper.shared.readString(for: Constants.StorageAuthkeys.RefreshToken)
          }
          set {
              if let value = newValue {
                  try? KeychainWrapper.shared.saveString(value, for:Constants.StorageAuthkeys.RefreshToken)
              } else {
                  KeychainWrapper.shared.delete(for: Constants.StorageAuthkeys.RefreshToken)
              }
          }
      }
    
}
