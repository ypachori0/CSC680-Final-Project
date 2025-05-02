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
    
    @State
    var sampletext: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("Second line of text")
        }
        .padding()
        
    }
}


#Preview {
    ContentView()
}
