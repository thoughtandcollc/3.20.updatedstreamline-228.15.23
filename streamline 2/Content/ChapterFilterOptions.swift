//
//  ChapterFilterOptions.swift
//  streamline
//
//  Created by Matt Forgacs on 9/28/21.
//

import SwiftUI

enum ChapterFilterOptions: Int, CaseIterable {
    case verses
//    case replies
    case media
    
    var title: String {
        switch self {
        
        case .verses: return "Verses"
            
   //     case .replies: return "Posts & Replies"
            
        case .media: return "Notes"
            
        }
    }
}

struct ChapterFilterOptionsView: View {
    @Binding var selectedOption: ChapterFilterOptions
    
    private let underlineWidth = UIScreen.main.bounds.width / CGFloat(ChapterFilterOptions.allCases.count)
    
    private var padding: CGFloat {
        let rawValue = CGFloat(selectedOption.rawValue)
        let count = CGFloat(ChapterFilterOptions.allCases.count)
        return ((UIScreen.main.bounds.width / count) * rawValue) + 16
   }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(ChapterFilterOptions.allCases, id: \.self) { option in
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


struct ChapterFilterOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterFilterOptionsView(selectedOption: .constant(.verses))
    }
}

