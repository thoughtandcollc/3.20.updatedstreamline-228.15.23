//
//  NewReading.swift
//  streamline
//
//  Created by Matt Forgacs on 6/11/21.
//

import SwiftUI
import Kingfisher

struct NewReading: View {
    @Binding var isPresented: Bool
    @State var captionText: String = ""
    @ObservedObject var viewModel: UploadReadingsViewModel
    
    var reading: Reading?
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
       self.viewModel = UploadReadingsViewModel(isPresented: isPresented)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top) {
                    if let user = AuthViewModel.shared.user {
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 64, height: 64)
                            .cornerRadius(32)
                    }
                   
                    TextArea("Must be Admin to Upload Focus Readings!", text: $captionText)
                    
                    Spacer()
                }
                
                .padding()
                
                .navigationBarItems(leading:
                                        Button(action: { isPresented.toggle()}, label: { Text("Cancel")
                                .foregroundColor(.black)
                                        }
                                        ),
                trailing: Button(action: {
                    viewModel.uploadReadings(caption: captionText)
                },
                
               label: {
                    Text("Upload")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                }))
                        Spacer()
            

            }
        }
    }
}
