//
//  RegistrationView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/26/21.
//

import SwiftUI
import WebKit
import SafariServices

struct RegistrationView: View {
    @State var email = ""
    @State var password = ""
    @State var fullname = ""
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?
    @State private var isLoading = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: AuthViewModel
    @State var hasNotAttachedProfilePicture = false
    @State var showTermsError = false
    @State var registrationErrorShown = false
    @State var registrationErrorMessage = ""
    @State private var showSafariView = false
    @State private var termsUrl = URL(string: "https://onthemargin.org/terms-conditions")!
    @State private var isTermsAccepted = false // for accepting terms
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: { showImagePicker.toggle() }, label: {
                    ZStack {
                        if let image = image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipped()
                                .cornerRadius(70)
                                .padding(.top, 68)
                                .padding(.bottom, 2)
                        } else {
                        Image("plus_photo")
                            .resizable()
                            .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .padding(.top, 68)
                            .padding(.bottom, 2)
                            .foregroundColor(.white)
                            }
                    }
                }) .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                    ImagePicker {(image, imageURL) in
                        selectedUIImage = image
                    }
                })
               
                Text("Add Your Profile Picture")
                    .foregroundColor(.white)
                    .padding()
                
                VStack(spacing: 20) {
                
                    CustomTextField(text: $fullname, placeholder: Text("Full Name"), imageName: "person")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
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
                
                Button(action: {
                    isLoading = true
                    guard isTermsAccepted == true else {
                        isLoading = false
                        showTermsError = true
                        return
                    }
                    guard let image = selectedUIImage else {
                        isLoading = false
                        hasNotAttachedProfilePicture = true
                        return
                    }
                    viewModel.registerUser(email: email, password: password, fullname: fullname, profileImage: image) { res in
                        switch(res) {
                        case .success:
                            isLoading = false
                        case .failure(let error):
                            isLoading = false
                            registrationErrorShown = true
                            registrationErrorMessage = "Registration did not succeed with error: \(error.localizedDescription)"
                        }
                    }
                           
                    
                        }, label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .frame(width: 360, height: 50)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .padding()
                })
                
                
                
                Spacer()
                
                
                VStack {
                    Button(action: {
                        showSafariView.toggle()
                    }, label: {
                        Text("Agree to Terms & Conditions and Privacy Policy")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    })
                    .sheet(isPresented: $showSafariView) {
                        SafariView(url: termsUrl).edgesIgnoringSafeArea(.bottom)
                    }
                    
                    HStack {
                        Image(systemName: isTermsAccepted ? "checkmark" : "")
                            .resizable()
                            .scaledToFill()
                            .padding(3)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .border(.white, width: 2)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isTermsAccepted.toggle()
                            }
                    }
                    Spacer()
                    
                    Button(action: {mode.wrappedValue.dismiss()}, label: {
                        HStack {
                            Text("Already have an account?")
                                .font(.system(size: 14))
                            
                            Text("Sign In")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                    })
                }
                
            }.alert("Please attach a profile Image to register", isPresented: $hasNotAttachedProfilePicture) {
                Button("Ok", action: {
                    isLoading = false
                })
            }
            .alert("Please accept terms & conditions", isPresented: $showTermsError) {
                Button("Ok", action: {
                    isLoading = false
                })
            }
            .alert("Registration Error", isPresented: $registrationErrorShown) {
                Button("Ok", role: .cancel) {
                    isLoading = false
                }
            }message: {
                Text("\(registrationErrorMessage)")
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(6)
            }

    }
        .background(Color(#colorLiteral(red: 0.9269468188, green: 0.5522589684, blue: 0.1965774, alpha: 1)))
        .ignoresSafeArea()
 
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
}

// MARK: - Safari View
// MARK: -
struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

