//
//  Router.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 08/01/26.
//

//Router class handle in app navigation

import Foundation
import SwiftUI
import Observation

//Auth Screen flow
public enum AppAuthFlow:Hashable{
    case createAccount
    case forgetPassord
}

//After login Route Screen Flow
enum AppRouteFlow: Hashable {
    case userProfile
    case UserList
    case userDetail(id:String)
    case completeProfile
    case chatList
    case chatView(id:String,otherName:String)
}

@Observable
class Router{
    //This is navigation stack
    var path = NavigationPath()
    
    //type of elements path will stor
    func push(destination:AppAuthFlow){
        path.append(destination)
    }
    
    //This is for after user is login and then move
    func pushApp(destination:AppRouteFlow){
        path.append(destination)
    }
    
    func backScreen(){
        path.removeLast()
    }
    //Clear the stack when auth changes based on
    
    func reset(){
        path.removeLast(path.count)
    }
}
