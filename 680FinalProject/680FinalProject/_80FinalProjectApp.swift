//
//  _80FinalProjectApp.swift
//  680FinalProject
//
//  Created by Thomas Bercasio on 4/21/25.
//

import SwiftUI
import Foundation
import CoreData

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
            MainView()
        }
    }
}

//class that handles authentication
class testAuth {
    private var email: String = ""
    private var password: String = ""
    
    private var user: User? = nil
    private var currentUserData: AuthDataResult? = nil
    
    private var successfulLogin: Bool = false
    
    //function to validate email using given regex pattern
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func checkAuth(){
        let semaphore = DispatchSemaphore(value: 0)
        print("Attempted to check authentification of email")
        Task{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
                if let error = error {
                    print("Error signing in: \(error)")
                    self?.successfulLogin = false
                } else {
                    print("Signed in successfully")
                    self?.successfulLogin = true
                    self?.currentUserData = authResult!
                }
            }
            semaphore.signal()
        }
        semaphore.wait()
        print("reached this line of code")
        if let testVal = self.currentUserData?.user.uid{
            print(testVal)
        }
    }
    
    func setEmail(email: String){
        self.email = email
    }
    func setPassword(password: String){
        self.password = password
    }
    func getSuccessfulLogin() -> Bool{
        return self.successfulLogin
    }
    func getCurrentUserData() -> AuthDataResult?{
        return self.currentUserData
    }
    
    //test function
    func testAddUser() -> Bool {
        print("Attempted to add user to database")
        Auth.auth().createUser(withEmail: "test@test.com", password: "Test!1234") { authResult, error in
            if let error = error {
                print("Error adding user: \(error)")
                return
            }
            print("User added successfully")
        }
        return true
    }
    
    //function to add users
    func addUser(email: String, password:String) -> Bool{
        print("Attempted to add user to database")
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error adding user: \(error)")
                return
            }
            print("User added successfully")
        }
        return true
    }
    func signOutCurrentUser() -> Bool{
        email = ""
        password = ""
        do {
            print("Attempting signout")
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            //if fails to signout return false
            print("Error signing out: %@", signOutError)
            return false
        }
        successfulLogin = false
        currentUserData = nil
        return true
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
    
    func writeExpenseData (UserID: String) async -> Bool{
        let db = Firestore.firestore()
        var expenseData: [String: Any] = [:]
        expenseData["Time"] = Timestamp(date: Date())
        expenseData["Description"] = "test description"
        expenseData["Amount"] = Double.random(in: 0...1000)
        do  {
            let randomInt: Int = Int.random(in: 1...20)
            try await db.collection("Expense").document(UserID).collection("Bills").document("3am Silicon Valley Coding Session \(randomInt)").setData(expenseData)
            print("Successfully wrote data to server")
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
}

//struct to hold event data
public struct EventData : Codable{
    @DocumentID var EventId: String?
    var Time: Timestamp
    var Location: String
    var Description: String
    var Cost : Float
    var EventName: String
    
    //need another struct containing an array of users
    //var AttendedBy: User
}

