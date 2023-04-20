//
//  CreateGroupView.swift
//  streamline
//
//  Created by Tayyab Ali on 18/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateGroupView: View {
    
    @Binding var isPresented: Bool
    @StateObject var viewModel: CreateGroupViewModel
    
    @State var showImagePicker = false
    @State var selectedUIImage : UIImage?
    @State var image           : Image?
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                VStack(spacing: 0) {
                    
                    ImagePickerView()
                    
                    NameView()
                    
                    DescriptionView()
                    
                }
                .navigationTitle(viewModel.createNewGroup ? "Create Group" : "Update Group")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: NavBarLeadingButton(), trailing: NavBarTrailingButton())
                .foregroundColor(Color("AdaptiveColor"))
                .padding()
                .toast(isPresenting: $viewModel.showToast) { viewModel.alertToast }
                .alert(item: $viewModel.alert, content: { alert in
                    Alert(title: Text("Success"), message: Text(alert.message), dismissButton: .default(Text("Ok")){
                        self.isPresented = false
                    })
                })
            }
        }
    }
    
    init(isPresented: Binding<Bool>, group: Group?) {
        _isPresented = isPresented
        _viewModel = StateObject(wrappedValue: CreateGroupViewModel(group: group))
    }
 
}

// MARK: - View Functions
// MARK: -
extension CreateGroupView {
    
    private func ImagePickerView() -> some View {
        
        Button(action: { showImagePicker.toggle() }, label: {
            
            ZStack {
                
                if let image = image {
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipped()
                        .cornerRadius(70)
                        .padding(.bottom, 16)
                    
                }
                else if viewModel.imageURL != nil {
                    
                    AnimatedImage(url: viewModel.imageURL)
                        .indicator(SDWebImageActivityIndicator.grayLarge)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipped()
                        .cornerRadius(70)
                        .padding(.bottom, 16)
                    
                }
                else {
                    
                    Image("plus_photo")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .padding(.bottom, 16)
                        .foregroundColor(.gray)
                    
                }
                
            }
        })
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
            ImagePicker { (image, imageURL) in
                selectedUIImage = image
            }
        })
    }
    
    private func NameView() -> some View {
        
        VStack {
            
            Text("Name")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Name your group", text: $viewModel.name)
                .font(.system(size: 14))
                .padding(.vertical, 10)
            
            Divider()
            
        }
        .padding(.bottom, 20)
        
    }
    
    private func DescriptionView() -> some View {
        
        VStack {
            
            Text("Description")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextArea("Write some description", text: $viewModel.description, horizontalPadding: 0, font: Font.system(size: 14))
            
        }
    }
    
    private func NavBarLeadingButton() -> some View {
        
        Button(action: {
            isPresented = false
        }, label: {
            Text("Cancel")
        })
        
    }
    
    private func NavBarTrailingButton() -> some View {
        
        Button {
            viewModel.createNewGroupInDatabase(image: selectedUIImage)
        } label: {
            
            Text(viewModel.createNewGroup ? "Create" : "Update")
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(viewModel.name.isEmpty ? Color.gray : Color.orange)
                .foregroundColor(.white)
                .clipShape(Capsule())
            
        }
        .disabled(viewModel.name.isEmpty)
        
    }
    
}

// MARK: - Helper Functions
// MARK: -
extension CreateGroupView {
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
}

// MARK: - Preview
// MARK: -
struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView(isPresented: .constant(true), group: Group())
    }
}
