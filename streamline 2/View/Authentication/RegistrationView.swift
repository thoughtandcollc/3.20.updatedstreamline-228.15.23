//
//  RegistrationView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/26/21.
//

import SwiftUI

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
                                .padding(.top, 88)
                                .padding(.bottom, 16)
                        } else {
                        Image("plus_photo")
                            .resizable()
                            .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .padding(.top, 88)
                            .padding(.bottom, 16)
                            .foregroundColor(.white)
                            }
                    }
                }) .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                    ImagePicker(image: $selectedUIImage)
                })
               
                
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
                    guard let image = selectedUIImage else {
                        return
                    }
                    viewModel.registerUser(email: email, password: password, fullname: fullname, profileImage: image)
                   
                    
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
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Agree to Terms & Conditions and Privacy Policy")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    })
                    
                    HStack {
                        Image("check")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
