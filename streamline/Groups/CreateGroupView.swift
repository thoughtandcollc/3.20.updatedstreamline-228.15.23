//
//  CreateGroupView.swift
//  streamline
//
//  Created by Tayyab Ali on 18/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateGroupView: View {
    
    @Environment(\.dismiss) var dismiss // for dismissing this view
    
    @StateObject var createModel: CreateGroupViewModel
    
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
                .navigationTitle(createModel.createNewGroup ? "Create Group" : "Update Group")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: NavBarLeadingButton(), trailing: NavBarTrailingButton())
                .foregroundColor(Color("AdaptiveColor"))
                .padding()
                .toast(isPresenting: $createModel.showToast) { createModel.alertToast }
                .alert(item: $createModel.alert, content: { alert in
                    Alert(title: Text("Success"), message: Text(alert.message), dismissButton: .default(Text("Ok")){
                        dismiss()
                    })
                })
            }
        }
    }
    
    init(group: Group?) {
        _createModel = StateObject(wrappedValue: CreateGroupViewModel(group: group))
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
                else if createModel.imageURL != nil {
                    
                    AnimatedImage(url: createModel.imageURL)
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
            
            TextField("Name your group", text: $createModel.name)
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
            
            TextArea("Write some description", text: $createModel.description, horizontalPadding: 0, font: Font.system(size: 14))
            
        }
    }
    
    private func NavBarLeadingButton() -> some View {
        
        Button(action: {
            dismiss()
        }, label: {
            Text("Cancel")
        })
        
    }
    
    private func NavBarTrailingButton() -> some View {
        
        Button {
            createModel.createNewGroupInDatabase(image: selectedUIImage)
        } label: {
            
            Text(createModel.createNewGroup ? "Create" : "Update")
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(createModel.name.isEmpty ? Color.gray : Color.orange)
                .foregroundColor(.white)
                .clipShape(Capsule())
            
        }
        .disabled(createModel.name.isEmpty)
        
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
        CreateGroupView(group: Group())
    }
}
