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
    private(set) var userList = [UserList]()
    private let apiService:APIServiceProtocol
    var isLoading = false
    var errorMessage: String?
    
    init(apiService: APIServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    func fetchUserList()async{
        isLoading = true
        errorMessage = nil
        do {
            userList = try await apiService.ftechUsers()
        }
        catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
