//
//  Router.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 08/01/26.
//

import Foundation
import SwiftUI
import Observation

public enum AuthFlow:Hashable{
    case createAccount
    case forgetPassord
}

//After login
enum AppFlow: Hashable {
    case home
    case UserList
    case userDetail(id:Int)
}

@Observable
class Router{
    //This is navigation stack
    var path = NavigationPath()
    //type of elements path will stor
    func push(destination:AuthFlow){
        path.append(destination)
    }
    
    func backScreen(){
        path.removeLast()
    }
    
    func moveToRootScreen(){
        path.removeLast(path.count)
    }
    // MARK: - Login Succes

    func loginSuccess() {
        path.removeLast(path.count)   // clear auth flow
        path.append(AppFlow.home)  // go to profile
    }
    
    func logout(){
        path.removeLast(path.count)
    }
    
    func pushApp(destination:AppFlow){
        path.append(destination)
    }
}
