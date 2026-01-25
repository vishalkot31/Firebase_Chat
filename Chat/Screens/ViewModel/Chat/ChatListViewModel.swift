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
    
    var userChatsList:[ChatListModel] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var serachQuery:String = ""
    private let chatService : ChatRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(chatService: ChatRepositoryProtocol = ChatListUser()) {
        self.chatService = chatService

    }

    var filteredChats: [(ChatListModel)]{
        guard !serachQuery.isEmpty else {
            return userChatsList
        }
        return userChatsList.filter {
            $0.otherUserName.localizedStandardContains(serachQuery)
        }
    }
    
    func fetchListChats(userId:String) {
        isLoading = true
        chatService.fetchChatsListUser(for: userId)
             .receive(on: DispatchQueue.main)
             .sink { completion in
                 if case let .failure(error) = completion {
                     self.errorMessage = error.localizedDescription
                 }
                 self.isLoading = false
             } receiveValue: { chats in
                 // Convert tuples to ChatListModel
                 self.userChatsList = chats.compactMap { tuple in
                    guard let chatId = tuple.chat.id else { return nil }
                        return ChatListModel(
                            id: chatId,
                            chat: tuple.chat,
                            otherUserName: tuple.otherUserName
                        )
                    }
                 self.isLoading = false
             }
             .store(in: &cancellables)
     }
}
