//
//  SettingsPage.swift
//  streamline
//
//  Created by Matt Forgacs on 8/18/21.
//

import SwiftUI

struct SettingsPage: View {
//    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var userInfo: UserInfo
   
    @State private var userDeleted = false
    @State private var showingAlert = false
    
    var body: some View {
        if userDeleted{
            LoginView()
        } else{
        VStack {
            Text("Delete My Account")
                .bold()
                .padding()
            
            Button {
                showingAlert = true
            } label: {
                Text("Delete Profile")
            }
            .alert("Are you sure you want to delete your account permanently?", isPresented: $showingAlert) {
                Button("NO", role: .cancel) { }
                Button("YES", role: .destructive) {
                    AuthViewModel.shared.deleteUser { deleteStatus in
                        if deleteStatus{
                            userDeleted = true
                        }
                    }
                }
            }
        
        
            
            
            Text("About Us")
                .bold()
                .padding()
            Text("Our vision is to be the bridge that connects the traditional Bible learning with our fast paced and digital world. Our ultimate goal is to increase the number of people who not only read the Bible, but become more engaged and understanding of the word of God.")
            
            Text("Terms of Service & Privacy Policy")
                .bold()
                .padding()
            Text("Introduction: These mobile application Standard Terms and Conditions written on this webpage shall manage your use of our mobile application, OnTheMargin accessible at www.OnTheMargin.org. These terms will be applied fully and affect to your use of this application. There is no tolerance for objectionable content or abusive users. Any user who breaks this policy according to admins subjective opinion may be removed and prohibted from using our service. We do not collect and or provide any personal user information to 3rd parties")
            
            Text("Report and Block a User")
                .bold()
                .padding()
            Text("http://www.onthemargin.org/report/")
            Text("*Subject to review by Admin*")
        } .padding()
        }
        }
    }

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
