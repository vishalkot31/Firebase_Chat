//
//  ChatViewModel.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 21/01/26.
//

import SwiftUI
import Observation
import Firebase
import Combine

@Observable
class ChatViewModel{
    
   var messages: [MessageModel] = []
   var txtMsg:String = ""
    private let chatService = ChatService()
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var myUserId: String?
    let otherUser: UserModel
    
    //for passing userid
    init(otherUser: UserModel) {
        self.otherUser = otherUser
    }
    
    //Call only view appear and start listening
    func injectMyUserID(_ id: String) {
         guard myUserId == nil else { return }
         myUserId = id
         startListening()
     }
    
    //Create chat id to identify chat between two users
    var chatId: String {
        guard let myUserId else { return "" }
        return [myUserId, otherUser.id ?? ""].sorted().joined(separator: "_")
    }
    //Single mesage send
    func sendMessage(){
       let text = txtMsg.trimmingCharacters(in: .whitespaces)
       guard !text.isEmpty else { return }
       txtMsg = ""
        chatService.sendMessage(
                chatId: chatId,
                senderId: myUserId ?? "", receiverID: otherUser.id ?? "",
                text: text
            )
           .sink { completion in
               if case let .failure(error) = completion {
                    print("Send failed:", error)
            }
           } receiveValue: {
               //No need to store return message
           }
        
           .store(in: &cancellables)
    }

    
    //Receving all mewssages form chat baed on id using combine
    func startListening() {
          chatService.listenToMessage(chatId: chatId)
              .receive(on: DispatchQueue.main)
              .sink(
                  receiveCompletion: { _ in },
                  receiveValue: { [weak self] messages in
                      self?.messages = messages
                  }
              )
              .store(in: &cancellables)
      }
}
