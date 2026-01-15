//
//  UserModel.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 10/01/26.
//

import Foundation


struct UserModel:Codable,Identifiable{
    var id: String
    var email:String
    var displayName:String
    var profileImageURL: String? = nil  // Optional profile picture URL
    var createdAt: Date = Date()
}


struct UserList:Codable,Identifiable{
    let id:Int
    let name:String
    let email:String
}
