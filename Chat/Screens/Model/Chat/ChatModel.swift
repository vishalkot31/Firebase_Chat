//
//  ChatModel.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 17/01/26.
//

import Foundation
import FirebaseFirestore

//This Conatin all details of chat between users and it is shared between both user
//Shared chat
struct ChatModel:Identifiable,Decodable{
    @DocumentID var id: String?//Chat id
    var participants:[String]
    let lastMessage: String
    let lastTimestampe: Timestamp
}
extension ChatModel {
    // Compute other user for this chat
    func otherUserId(currentUserId: String) -> String? {
        participants.first { $0 != currentUserId }
    }
}

//It contain induvidual chat message to be added for Chatmodel
//Shared message
struct MessageModel: Identifiable,Codable{
    @DocumentID var id: String?
    let message: String
    let timestamp: Timestamp
    let senderID:String
}

struct ChatListModel: Identifiable,Hashable,Equatable {
    let id: String           // chatId
    let chat: ChatModel
    let otherUserName: String
    static func == (lhs: ChatListModel, rhs: ChatListModel) -> Bool {
           return lhs.id == rhs.id   // equality based only on chatId
       }
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
}
