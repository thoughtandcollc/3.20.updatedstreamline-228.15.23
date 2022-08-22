//
//  ChapterView.swift
//  streamline
//
//  Created by Matt Forgacs on 9/24/21.
//

import SwiftUI
import Kingfisher

struct ChapterView: View {
    let chapter: Chapter
    @State var selectedFilter: ChapterFilterOptions = .verses
  //  @ObservedObject var viewModel: ChapterProfileViewModel
    
    var body: some View {
        VStack {
            Image("Focus7")
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 120, height: 120)
                .cornerRadius(120 / 2)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            
            Text(chapter.fullname)
                .font(.system(size: 16, weight: .semibold))
                .padding(.top, 8)
            
            Text("NIV Version")
                .font(.subheadline)
                .foregroundColor(.gray)
            
//            Text("Maybe a little intro")
//                .font(.system(size: 14))
//                .padding(.top, 8)
            
            HStack(spacing: 40) {
                VStack {
                    Text("450M")
                        .font(.system(size: 16)).bold()
                    
                    Text("Readers")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                }
                
                VStack {
                    Text("1")
                        .font(.system(size: 16)).bold()
                    
                    Text("Following")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
//                VStack {
//                    NavigationLink(
//                        destination: SettingsPage(),
//                        label: {
//                            Text("Settings")
//                        })
//                }
            }
            .padding()
            
            ChapterFilterOptionsView(selectedOption: $selectedFilter)
            Spacer()
        }
    }
}

//struct ChapterView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChapterView()
//    }
//}
