//
//  LoginView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/26/21.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showErrorDialogue = false
    @State var errorMessage = ""
    @State private var showForgotPassword = false
    
    var body: some View {
    NavigationView {
            ZStack {
                VStack {
                    Image("OnTheMargin2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 400, height: 200)
                        .padding(.top, 100)
                        .padding(.bottom, 50)
                    
                    VStack(spacing: 20) {
                        CustomTextField(text: $email, placeholder: Text("Email"), imageName: "envelope")
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        CustomSecureField(text: $password, placeholder: Text("Password"))
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 32)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {showForgotPassword.toggle()}, label: {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 16)
                                .padding(.trailing, 32)
                            
                        })
                        .fullScreenCover(isPresented: $showForgotPassword) {
                            ForgotPasswordView(email: $email)
                        }
                    }
                    
                    Button(action: {
                        viewModel.login(withEmail: email, password: password) { res in
                            switch(res){
                            case .success:
                                print("succeeded")
                            case .failure(let error):
                                showErrorDialogue = true
                                errorMessage = "Login did not succeed with error: \(error.localizedDescription)"
                            }
                        }
                    }, label: {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .frame(width: 360, height: 50)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .padding()
                    }).alert("Login Error", isPresented: $showErrorDialogue) {
                        Button("OK") {}
                    }message: {
                       Text("\(errorMessage)")
                    }
                    Spacer()
                    
                    NavigationLink(
                        destination: RegistrationView().navigationBarBackButtonHidden(true),
                        label: {
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14))
                                
                                Text("Sign Up")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.bottom, 40)
                        })
                    
                }
            }
            .background(Color(#colorLiteral(red: 0.9269468188, green: 0.5522589684, blue: 0.1965774, alpha: 1)))
            .ignoresSafeArea()
        }
    .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
