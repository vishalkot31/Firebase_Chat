//
//  ChatModel.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 17/01/26.
//

import Foundation

//This conatain all details of chat between users
struct ChatModel:Identifiable,Decodable{
    let id = UUID()
    let name: String
    var participants:[String]
    let avatar: String
    let lastMessage: String
    let lastTimestamp: String
    
}

//It contain induvidual chat message
struct MessageModel: Identifiable,Codable{
    let id = UUID()
    let message: String
    let timestamp: Date
    let senderID:String
    let receiverId: String
    
}
