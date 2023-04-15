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
  //  @EnvironmentObject var userInfo: UserInfo
    var fcmToken: String?
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (Result<AnyObject?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to login: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            completion(.success(result))
            self.userSession = result?.user
            self.fetchUser()
        }
    }
    
    func registerUser(email: String, password: String,
                      fullname: String, profileImage: UIImage, completion: (@escaping (Result<AnyObject, Error>) -> Void)) {
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(filename)
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
                        
            storageRef.downloadURL { url, _ in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("DEBUG: Error \(error.localizedDescription)")
                        completion(.failure(error))
                        return
                    }
                    
                    guard let user = result?.user else { return }
                    
                    let data = ["email": email,
                                "fullname": fullname,
                                "profileImageUrl": profileImageUrl,
                                "uid": user.uid]
                    completion(.success(user))
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
        let query = Firestore.firestore().collection("users").document(uid)
        query.getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            self.user = User(dictionary: data)
            
        //    self.fetchUserStats()
        }
    }
    
    func deleteUser(_ completion: @escaping ((Bool) -> Void)) {
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
              print("DEBUG: Failed to upload image \(error.localizedDescription)")
              completion(false)
          } else {
              self.userSession = nil
              self.user = nil
              completion(true)
//              self.deleteComments()
          }
        }
    }
    
    func forgotPassword(email: String) {
        
        // hide keyboard
        dismissKeyboard()
        
        var email = email.removeSpaces().lowercased()
        
        guard email.isValidEmail() else {
            customAlertApple(title: "Error", message: "Invalid Email", yesButtonTitle: "Okay", showDestructive: false)
            return
        }
        
        // show progress bar
        ProgressHUD.show()
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            
            // hide progress bar
            ProgressHUD.dismiss()
            
            // handle error
            guard error == nil else {
                customAlertApple(title: "Error", message: error!.localizedDescription, yesButtonTitle: "Okay", showDestructive: false)
                return
            }
            
            // success
            customAlertApple(title: "Success", message: "Please check your email for password reset", yesButtonTitle: "Okay", showDestructive: false)
            
        }
        
        
    }
    
//    static func saveProfileImage(profileImage: UIImage, imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onError: @escaping(_ errorMessage: String) -> Void) {
//        
//        storageProfileImageRef.putData(imageData, metadata: metaData) {
//            (StorageMetadata, error) in
//            
//            if error != nil {
//                onError(error!.localizedDescription)
//                return
//            }
//            storageProfileImageRef.downloadURL {
//                (url, error) in
//                if let metaImageUrl = url?.absoluteString {
//                    
//                    if let changeRequest =
//                        Auth.auth().currentUser?.createProfileChangeRequest() {
//                        changeRequest.photoURL = url
//                        changeRequest.commitChanges(error) in
//                        if error != nil {
//                            onError(error?.localizedDescription)
//                            return
//                        }
//                    }
//                }
//                let firestoreUserId = AuthService.getUserID(userId: userId)
//                let user = User.init(profileImage: profileImage)
//            }
//        }
//    }
    
    
    
    func tabTitle(forIndex index: Int) -> String {
        switch index {
        case 0: return "Readings"
        case 1: return "Notes"
        case 2: return "Messages"
        case 3: return "Main Content"
//        case 4: return "Wa"
        default: return ""
        }
    }
    
    
}

