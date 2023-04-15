//
//  ForgotPasswordView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 15/04/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.dismiss) var dismiss // for dismissing this view
    @EnvironmentObject var viewModel: AuthViewModel
    
    @Binding var email: String    
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                VStack {
                    
                    LogoImageView()
                    
                    EmailView()
                    
                    Spacer()
                    
                    ResetButtonView()
                    
                }
                
            }
            //.background(NavigationLinkView())
            .background(Color(#colorLiteral(red: 0.9269468188, green: 0.5522589684, blue: 0.1965774, alpha: 1)))
            .ignoresSafeArea()
            .toolbar { TopRightButtonView() }
            .onAppear { onAppearHandling() }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}




// MARK: - View Functions
// MARK: -
extension ForgotPasswordView {
    
    private func TopRightButtonView() -> some ToolbarContent {
        
        // button on top right
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                dismiss() // dismiss the screen
            } label: {
                Text("Cancel").foregroundColor(.white)
            }
        }
    }
    
    private func LogoImageView() -> some View {
        
        Image("OnTheMargin2")
            .resizable()
            .scaledToFill()
            .frame(width: 400, height: 200)
            .padding(.top, 100)
            .padding(.bottom, 50)
        
    }
    
    private func EmailView() -> some View {
        
        CustomTextField(text: $email, placeholder: Text("Email"), imageName: "envelope")
            .padding()
            .background(Color(.init(white: 1, alpha: 0.15)))
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
        
    }
    
    private func ResetButtonView() -> some View {
        
        Button(action: {
            viewModel.forgotPassword(email: email)
        }, label: {
            Text("Reset Password")
                .font(.headline)
                .foregroundColor(.orange)
                .frame(width: 360, height: 50)
                .background(Color.white)
                .clipShape(Capsule())
                .padding()
        })
        .padding(.bottom)
        
    }
    
}


// MARK: - Preview
// MARK: -
struct ForgotPasswordView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ForgotPasswordView(email: .constant(""))
        
    }
}

