//
//  ChatListUser.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 22/01/26.
//

import Foundation
import FirebaseFirestore
import Combine


protocol ChatRepositoryProtocol {
    func fetchActiveChats(for userId: String) -> AnyPublisher<[ChatModel], Error>
}

class ChatListUser:ChatRepositoryProtocol{
     private let db = Firestore.firestore()
    //Fetch active chats between user
    func fetchActiveChats(for userId: String) -> AnyPublisher<[ChatModel], Error> {
        
        Future<[ChatModel], Error> { promise in
            self.db.collection("chats")
                .whereField("participants", arrayContains: userId)
                .order(by: "timestamp", descending: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    let chats: [ChatModel] = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: ChatModel.self)
                    } ?? []
                    
                    promise(.success(chats))
                }
        }
        .eraseToAnyPublisher()
    }
}

//Fetch all users


protocol FetchUserListRespoitoryProtocol {
    func fetchAllUsers() async throws -> [UserModel]
}
class FetchUserListRespoitory:FetchUserListRespoitoryProtocol{
    private let db = Firestore.firestore()
    func fetchAllUsers() async throws -> [UserModel] {
        let snapshot = try await db.collection("users").getDocuments()
        let users: [UserModel] = snapshot.documents.compactMap { doc in
            try? doc.data(as: UserModel.self)
        }
        return users
    }
}
