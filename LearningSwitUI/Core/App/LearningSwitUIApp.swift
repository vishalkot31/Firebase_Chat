//
//  LearningSwitUIApp.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 02/01/26.
//

import SwiftUI
import UIKit
import FirebaseCore

//main entry

class AppDelegate:NSObject,UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct LearningSwitUIApp: App {
    //Register app Delegate for firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var router = Router()
    @State private var userModel = UserSession()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
