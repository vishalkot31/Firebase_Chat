//
//  ChatModel.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 17/01/26.
//

import Foundation

struct ChatModel:Identifiable{
    let id = UUID()
    let name: String
    let avatar: String
    let lastMessage: String
    let time: String
//    var unreadCount: Int
//    var isOnline: Bool
//        var isPinned: Bool
//        var isMuted: Bool
    
}
