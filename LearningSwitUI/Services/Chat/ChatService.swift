//
//  ChatService.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 22/01/26.
//

import Foundation
import Combine
import FirebaseFirestore

class ChatService{
    private let db = Firestore.firestore()
    var listener: ListenerRegistration?
    
    //Send Message to firebase
    func sendMessage(chatId:String,senderId:String,receiverID:String,text:String)->AnyPublisher<Void,Error>{
        Future{ [self]  promise in
            let message = MessageModel(
                message: text,
                timestamp: Date(),
                senderID: senderId, receiverId: receiverID)
            
            do {
                try self.db.collection("chats")
                            .document(chatId)
                            .collection("messages")
                            .addDocument(from: message)

                // update chat list info
                    self.db.collection("chats")
                    .document(chatId)
                    .setData(["participants": [senderId,receiverID],
                            "lastMessage": text,
                            "lastTimestamp": Date(),
                            "isFromUser": true,
                            "senderID":senderId,
                            "receiverId": receiverID], merge: true)
                    promise(.success(()))
            }
            catch{
                promise(.failure(error))
            }
            
        }.eraseToAnyPublisher()
    }
    
    
    //Listen to message that recived
    
    func listenToMessage(chatId:String) -> AnyPublisher<[MessageModel], Error> {

        let subject = PassthroughSubject<[MessageModel], Error>()

        listener = db.collection("chats")
                   .document(chatId)
                   .collection("messages")
                   .order(by: "timestamp")
                   .addSnapshotListener { snapshot, error in

                    if let error = error {
                        subject.send(completion: .failure(error))
                        return
                    }

                    let messages = snapshot?.documents.compactMap {
                        try? $0.data(as: MessageModel.self)
                    } ?? []

                       subject.send(messages)
                   }

               return subject.eraseToAnyPublisher()
    }
    
    func removeListener() {
        listener?.remove()
    }
}
