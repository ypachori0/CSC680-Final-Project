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

//main window of project
@main
struct _80FinalProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let eventData = testBackend()
    var body: some Scene {
        WindowGroup {
            ContentView()
            Text("\(eventData.getData())")
        }
    }
}

@Observable
class testBackend{
    var sampletext: String = ""

    //async function to test pulling data from db.
    func testData() async -> String {
        let db = Firestore.firestore()
        let docRef: DocumentReference = db.collection("Event").document("TestEvent")
        var eventData = ""
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "this gets typed out instead"
                eventData = dataDescription
            }
            else {
                print("Document does not exist")
            }
        }
        catch {
            print("Error getting document: \(error)")
        }
        return eventData
    }
    //converts async function call to regular context
    func getData() -> String{
        Task{
            sampletext = await testData()
        }
        print("\(sampletext)")
        return sampletext
    }
    
    //TODO add functions to add/update data in db
}

//struct to hold event data
struct VacationEvent : Codable{
    @DocumentID var id: String?
    var Time: Timestamp
    var Location: String
    var Description: String
    var Cotst : Float
    var EventName: String
}

