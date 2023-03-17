//
//  DailyView.swift
//  streamline
//
//  Created by Matt on 10/4/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct DailyView: View {
    var body: some View {
        
        VStack {
            
            Text("Courage")
                .font(.system(size: 50))
                .fontWeight(.medium)
                .padding(.vertical, 60)
            
            Image("batman")
                .resizable()
                .aspectRatio(contentMode: .fill)
     
            
                ZStack(alignment: .bottomLeading) {
                    
                    
                    VStack {
                        Spacer()
                        HStack {
                            Text("The Daily Word")
                                .padding(.horizontal)
                                .foregroundColor(.black)
                            .font(.system(size: 32, weight: .semibold))
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "arrow.right.circle")
                                    .font(.system(size: 40))
                                    .foregroundColor(.black)
                            }

                            
                        } .padding()
                    }
                    
                }
                .cornerRadius(16)
            
            
        } .background(Color.orange)
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
    }
}
