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
    @State private var session = UserSession()
    @AppStorage("userData") private var userData: Data?
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(session)
            .task {
                // Restore session once at app launch
                    if let data = userData,
                        let saveduser =  try? JSONDecoder().decode(UserModel.self, from: data){
                        session.login(saveduser)
                    }
                    else{
                        // 2️⃣ If no local data, restore asynchronously from Firestore
                        await session.restoreUserIfNeeded()
                    }

                }
        }
    }
}
