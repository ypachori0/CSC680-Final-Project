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

//initializes firestore db
let db = Firestore.firestore()

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
    let eventData = testBackend()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class testBackend{
    var sampletext: String = ""
    
    //function to test pulling data from db.
    func testData() async -> String {
        let db = Firestore.firestore()
        let docRef: DocumentReference = db.collection("events").document("TestEvent")
        var eventData = ""
        do {
          let document = try await docRef.getDocument()
          if document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            eventData = dataDescription
            print("Document data: \(dataDescription)")
          } else {
            print("Document does not exist")
          }
        } catch {
          print("Error getting document: \(error)")
        }
        return eventData
    }
    
    func getData(){
        Task{
            sampletext = await self.testData()
        }
    }
}


