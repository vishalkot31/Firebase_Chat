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
    
    //Send Message to firebase using future
    func sendMessage(chatId:String,senderId:String,receiverID:String,text:String)->AnyPublisher<Void,Error>{
        
        Future{ [self]  promise in
                //create messsage modewl
            let message = MessageModel(
                message: text,
                timestamp: Timestamp(date: Date()),
                senderID: senderId)
            
            do {
                try self.db.collection("chats")
                            .document(chatId)
                            .collection("messages")
                            .addDocument(from: message)
                //it will create one message add inside chat doument

                // update chat list info
                    self.db.collection("chats")
                    .document(chatId)
                    .setData(["participants": [senderId,receiverID],
                            "lastMessage": text,
                            "lastTimestampe": Date()],merge: true)
                    promise(.success(()))
            }
            catch{
                promise(.failure(error))
            }
            
        }.eraseToAnyPublisher()
    }
    
     
    //Listen to message that recived and return all messages based on chatid
    
    func listenToMessage(chatId:String) -> AnyPublisher<[MessageModel], Error> {
        
        let subject = PassthroughSubject<[MessageModel], Error>()
        //firsetore update -> event is trigeered -> UI Reacts
        listener = db.collection("chats")
                   .document(chatId)
                   .collection("messages")
                   .order(by: "timestamp")
                   .addSnapshotListener { snapshot, error in//real time sysnc
                    if let error = error {
                        subject.send(completion: .failure(error))
                        return
                    }
                       //Return allmessages
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
