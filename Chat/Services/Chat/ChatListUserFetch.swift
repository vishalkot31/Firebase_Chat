//
//  ChatListUser.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 22/01/26.
//

import Foundation
import FirebaseFirestore
import Combine

//Checking new  branch
protocol ChatRepositoryProtocol {
    func fetchChatsListUser(for currentUserId: String) -> AnyPublisher<[(chat: ChatModel, otherUserName: String)], Error>
}

class ChatListUser:ChatRepositoryProtocol{
     private let db = Firestore.firestore()
    //Fetch active chats between user
    func fetchChatsListUser(for currentUserId: String) -> AnyPublisher<[(chat: ChatModel, otherUserName: String)], Error> {
        Future { promise in
            //find all chat with current user id
            let chatsRef = self.db.collection("chats")
                .whereField("participants", arrayContains: currentUserId)
                .order(by: "lastTimestampe", descending: true)
            
            chatsRef.getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                let chatDocs = snapshot?.documents ?? []
                var result: [(chat: ChatModel, otherUserName: String)] = []
                let group = DispatchGroup()
                
                //from each chat het other user id and from that fetch user collllection to get name
                for doc in chatDocs {
                    guard let chat = try? doc.data(as: ChatModel.self),
                          let otherId = chat.otherUserId(currentUserId: currentUserId), !otherId.isEmpty  else { continue }
                    print(otherId)
                    print(chat.lastMessage)
                    group.enter()
                    
                    // Fetch other user's name from 'users' collection
                    self.db.collection("users")
                        .document(otherId)
                        .getDocument { userSnap, _ in
                            let name = userSnap?["fullName"] as? String ?? "Unknown"
                            result.append((chat: chat, otherUserName: name))
                            group.leave()
                        }
                }
                
                group.notify(queue: .main) {
                    promise(.success(result))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

//Fetch all users from firebase


protocol FetchUserListRespoitoryProtocol {
    func fetchAllUsers() async throws -> [UserModel]
}

//Returns all users from user collection
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
