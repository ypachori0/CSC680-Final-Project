//
//  ContentView.swift
//  680FinalProject
//
//  Created by Thomas Bercasio on 4/21/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            let backendTest = testBackend()

        }
        .padding()
        
    }
}

class testBackend{
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
}

#Preview {
    
    ContentView()
}
