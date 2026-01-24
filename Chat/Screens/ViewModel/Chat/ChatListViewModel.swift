//
//  ChatListViewModel.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 22/01/26.
//

import Foundation
import Observation
import Combine

@Observable
@MainActor
class ChatListViewModel{
    var activeChats: [ChatModel] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private let chatService : ChatRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private let currentUserId: String
    
    init(chatService: ChatRepositoryProtocol = ChatListUser(),currentUserId: String) {
        self.chatService = chatService
        self.currentUserId = currentUserId

    }

    func fetchChats() {
        chatService.fetchActiveChats(for: currentUserId)
             //.receive(on: DispatchQueue.main)
             .sink { completion in
                 if case let .failure(error) = completion {
                     self.errorMessage = error.localizedDescription
                 }
             } receiveValue: { chats in
                 self.activeChats = chats
             }
             .store(in: &cancellables)
     }
}
