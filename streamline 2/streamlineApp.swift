//
//  streamlineApp.swift
//  streamline
//
//  Created by Matt Forgacs on 5/23/21.
//

import SwiftUI
import Firebase

@main
struct streamlineApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel.shared)
        
            
        }
    }
}
  
