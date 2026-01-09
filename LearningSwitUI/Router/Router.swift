//
//  Router.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 08/01/26.
//

import Foundation
import SwiftUI

public enum AuthFlow:Hashable{
    case createAccount
    case forgetPassord
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
}
