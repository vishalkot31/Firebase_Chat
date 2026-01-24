//
//  ChatModel.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 17/01/26.
//

import Foundation
import FirebaseFirestore

//This conatain all details of chat between users
struct ChatModel:Identifiable,Decodable{
    @DocumentID var id: String?
    let name: String
    var participants:[String]
    let avatar: String
    let lastMessage: String
    let lastTimestamp: String
    
}

//It contain induvidual chat message
struct MessageModel: Identifiable,Codable{
    @DocumentID var id: String?
    let message: String
    let timestamp: Date
    let senderID:String
    let receiverId: String
    
}
