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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    
//    init() {
//        FirebaseApp.configure()
//    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel.shared)
        
            
        }
    }
}

