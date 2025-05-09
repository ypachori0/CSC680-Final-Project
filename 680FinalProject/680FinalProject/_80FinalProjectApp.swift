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
    
    @State
    var someText: String = ""
    
    @State
    var balance: Double = 0.0
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            //Text("\(eventData.getData())")
            TextField("Enter Event Name: ", text: $someText).textFieldStyle(.roundedBorder).padding()
            Button(action: {
                print("Button Pressed")
                eventData.updateTestData()
            }) {
                Text("Submit")
            }
        }
    }
}

@Observable
class testBackend{
    var sampletext: String = ""

    //async function to test pulling data from db.
    func testReadData() async -> String {
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
    
    //TODO to write data to DB change parameter to accept any number of args
    func testWriteData() async -> Bool{
        let db = Firestore.firestore()
        var eventData: [String: Any] = [:]
        eventData["Time"] = Timestamp(date: Date())
        eventData["Location"] = "test location"
        eventData["Description"] = "test description"
        eventData["Cost"] = Double.random(in: 0...1000)
        eventData["EventName"] = "test event"
        do  {
            try await db.collection("Event").document("TestEvent").setData(eventData)
            return true
        } catch {
            print("Error writing document to db: \(error)")
            return false
        }
    }
    //write function that takes an event data struct as argument and returns whether or not it successfully wrote data to the db
    func writeEventData() async -> Bool{
        let db = Firestore.firestore()
        var eventData: [String: Any] = [:]
        eventData["Time"] = Timestamp(date: Date())
        eventData["Location"] = "test location"
        eventData["Description"] = "test description"
        eventData["Cost"] = Double.random(in: 0...1000)
        eventData["EventName"] = "test event"
        do  {
            try await db.collection("Event").document("TestEvent").setData(eventData)
            return true
        } catch {
            print("Error writing document to db: \(error)")
            return false
        }
    }
    
    // function to call test write from non async context
    func updateTestData() -> Void{
        Task{
            let successfulWrite = await testWriteData()
            if(successfulWrite){
                print("Data successfully written to db")
            }else {
                print("Data write failed")
            }
        }
    }
    //converts async function call to non async context
    func getTestData() -> String{
        Task{
            sampletext = await testReadData()
        }
        print("\(sampletext)")
        return sampletext
    }
    
    //TODO add functions to add/update data in db
}

//struct to hold event data
public struct EventData : Codable{
    @DocumentID var EventId: String?
    var Time: Timestamp
    var Location: String
    var Description: String
    var Cost : Float
    var EventName: String
}

