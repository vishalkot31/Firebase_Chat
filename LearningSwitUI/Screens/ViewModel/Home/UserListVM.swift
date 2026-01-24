//
//  UserListVM.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 15/01/26.
//

import Foundation
import Observation


@Observable
@MainActor
class UserListVM{
    private(set) var userList = [UserModel]()
    private let apiService:FetchUserListRespoitoryProtocol
    var isLoading = false
    var errorMessage: String?
    
    init(apiService: FetchUserListRespoitoryProtocol = FetchUserListRespoitory()) {
        self.apiService = apiService
    }
    
    //Ftech list of all users
    func fetchUserList(session:UserSession)async{
        isLoading = true
        errorMessage = nil
        do {
            let userListFteched = try await apiService.fetchAllUsers()
            //remove self user
            userList = userListFteched.filter{$0.id != session.user?.id}
        }
        catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
