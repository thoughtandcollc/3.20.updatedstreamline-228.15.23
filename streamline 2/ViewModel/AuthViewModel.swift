//
//  AuthViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 5/27/21.
//
import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var isAuthenticating = false
    @Published var error: Error?
    @Published var user: User?
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to login: \(error.localizedDescription)")
                return
            }
            
            self.userSession = result?.user
            self.fetchUser()
        }
    }
    
    func registerUser(email: String, password: String,
                      fullname: String, profileImage: UIImage) {
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(filename)
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
                        
            storageRef.downloadURL { url, _ in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("DEBUG: Error \(error.localizedDescription)")
                        return
                    }
                    
                    guard let user = result?.user else { return }
                    
                    let data = ["email": email,
                                "fullname": fullname,
                                "profileImageUrl": profileImageUrl,
                                "uid": user.uid]
                    
                    Firestore.firestore().collection("users").document(user.uid).setData(data) { _ in
                        self.userSession = user
                        self.fetchUser()
                    }
                }
            }
        }
    }
    
//    func fetchUserStats() {
//        guard let user = self.user else { return }
//        UserService.fetchUserStats(user: user) { stats in
//            self.user?.stats = stats
//        }
//    }
    
    func signOut() {
        userSession = nil
        user = nil
        try? Auth.auth().signOut()
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            self.user = User(dictionary: data)
            
        //    self.fetchUserStats()
        }
    }
    
    
    
    func tabTitle(forIndex index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Focus Reading"
        case 2: return "Notes"
        case 3: return "Notifications"
        case 4: return "Main Content"
        default: return ""
        }
    }
    
    
}


//import SwiftUI
//import Firebase
//
//class AuthViewModel: ObservableObject {
//    @Published var userSession: FirebaseAuth.User?
//    @Published var isAuthenticating = false
//    @Published var error: Error?
//    @Published var user: User?
//
//    static let shared = AuthViewModel()
//
//
//    init() {
//        userSession = Auth.auth().currentUser
//        fetchUser()
//    }
//
//    func login(withEmail email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//            print("DEBUG: Failed to login: \(error.localizedDescription)")
//            return
//            }
//
//            self.userSession = result?.user
//            self.fetchUser()
//        }
//    }
//
//    func registerUser(email: String, password: String, fullname: String, profileImage: UIImage) {
//
//        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
//        let filename = NSUUID().uuidString
//        let storageRef = Storage.storage().reference().child(filename)
//
//        storageRef.putData(imageData, metadata: nil) { _, error in
//            if let error = error {
//                print("DEBUG: Failed to upload image \(error.localizedDescription)")
//                return
//            }
//
//            print("DEBUG: Successfully uploaded user data..")
//
//            storageRef.downloadURL { url, _ in
//                guard let profileImageUrl = url?.absoluteString else { return }
//
//                Auth.auth().createUser(withEmail: email, password: password) { result, error in
//                    if let error = error {
//                        print("DEBUG: Error \(error.localizedDescription)")
//                        return
//                    }
//
//                    guard let user = result?.user else { return }
//
//                    let data = ["email": email,
//                                "fullname": fullname,
//                                "profileImageUrl": profileImageUrl,
//                                "uid": user.uid]
//
//
//                    Firestore.firestore().collection("users").document(user.uid).setData(data) { _ in
//                        self.userSession = user
//                        self.fetchUser()
//
//                        }
//                    }
//                }
//            }
//        }
//        func signOut() {
//            userSession = nil
//            user = nil
//            try? Auth.auth().signOut()
//
//        }
//
//    func fetchUser() {
//        guard let uid = userSession?.uid else { return }
//
//        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
//            guard let data = snapshot?.data() else { return }
//            self.user = User(dictionary: data)
//
//        }
//    }
//}
