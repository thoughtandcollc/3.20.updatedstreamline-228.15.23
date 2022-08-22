//
//  FilterButtonView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/25/21.
//

import SwiftUI

enum PostFilterOptions: Int, CaseIterable {
    case posts
//    case replies
    case likes
    
    var title: String {
        switch self {
        
        case .posts: return "Reading"
            
   //     case .replies: return "Posts & Replies"
            
        case .likes: return "Notes"
            
        }
    }
}

struct FilterButtonView: View {
    @Binding var selectedOption: PostFilterOptions
    
    private let underlineWidth = UIScreen.main.bounds.width / CGFloat(PostFilterOptions.allCases.count)
    
    private var padding: CGFloat {
        let rawValue = CGFloat(selectedOption.rawValue)
        let count = CGFloat(PostFilterOptions.allCases.count)
        return ((UIScreen.main.bounds.width / count) * rawValue) + 16
   }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(PostFilterOptions.allCases, id: \.self) { option in
                    Button(action: {
                        self.selectedOption = option
                    }, label: {
                            Text(option.title)
                                .frame(width: underlineWidth - 8)
                        })
                }
            }
            Rectangle()
                .frame(width: underlineWidth - 32, height: 3, alignment: .center)
                .foregroundColor(.orange)
                .padding(.leading, padding)
                .animation(.spring())
        }
    }
}

struct FilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FilterButtonView(selectedOption: .constant(.posts))
    }
}
