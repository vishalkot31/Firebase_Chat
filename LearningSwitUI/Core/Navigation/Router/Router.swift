//
//  Router.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 08/01/26.
//

import Foundation
import SwiftUI
import Observation

//Auth Screen
public enum AuthFlow:Hashable{
    case createAccount
    case forgetPassord
}

//After login Route app
enum AppRoute: Hashable {
    case home
    case UserList
    case userDetail(id:Int)
    case completeProfile
    case chatList
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
        path.append(AppRoute.completeProfile)  // go to profile
    }
    
    func logout(){
        path.removeLast(path.count)
    }
    
    func pushApp(destination:AppRoute){
        path.append(destination)
    }
}
