//
//  GroupDetailView.swift
//  streamline
//
//  Created by Sibtain Ali on 02-08-2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct GroupDetailView: View {
    
    @Environment(\.dismiss) var dismiss // for dismissing this view
    
    @ObservedObject var searchModel: SearchGroupViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ImagePickerView()
            
            FieldView("Name", searchModel.selectedGroup.name)
            
            FieldView("Description", searchModel.selectedGroup.description ?? "")
            
            Spacer()
            
            JoinGroupButton()
            
        }
        .navigationTitle(searchModel.selectedGroup.name)
        .navigationBarTitleDisplayMode(.inline)
        .foregroundColor(Color("AdaptiveColor"))
        .padding()
        
        
    }
 
}

// MARK: - View Functions
// MARK: -
extension GroupDetailView {
    
    private func ImagePickerView() -> some View {
        
        AnimatedImage(url: URL(string: searchModel.selectedGroup.imageURL ?? ""))
            .indicator(SDWebImageActivityIndicator.grayLarge)
            .resizable()
            .scaledToFill()
            .frame(width: 140, height: 140)
            .clipped()
            .cornerRadius(70)
            .padding(.bottom, 16)

    }
    
    private func FieldView(_ title: String, _ description: String) -> some View {
        
        VStack {
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            

            Text(description)
                .font(.system(size: 14))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
        }
        .padding(.bottom, 20)
        
    }
    
    private func NavBarLeadingButton() -> some View {
        
        Button(action: {
            dismiss()
        }, label: {
            Text("Cancel")
        })
        
    }
    
    private func JoinGroupButton() -> some View {
        
        Button {
            searchModel.groupTapped()
        } label: {
            Text(searchModel.getRequestStatus())
                .bold()
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(Color(.systemOrange))
                .cornerRadius(8)
                .defaultShadow()
        }

    }

}


// MARK: - Preview
// MARK: -
struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(searchModel: SearchGroupViewModel())
    }
}
