//
//  _80FinalProjectApp.swift
//  680FinalProject
//
//  Created by Thomas Bercasio on 4/21/25.
//

import SwiftUI

// firebase dependencies
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

//on app launc init firebase
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct _80FinalProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
