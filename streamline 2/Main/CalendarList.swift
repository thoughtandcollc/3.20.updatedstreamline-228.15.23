//
//  CalendarPage.swift
//  streamline
//
//  Created by Matt Forgacs on 8/2/21.
//

import SwiftUI

struct CalendarList: View {
    var bibles: [Bible] = BibleList.upcomingReadings
    
    var body: some View {
    NavigationView {
        List(bibles, id: \.id) { bible in
            NavigationLink(destination: FocusedReadingDetailView(bible: bible), label: {
                BibleCell(bible: bible)
            })
        }
        .navigationTitle("Featured Readings")
    } 
    }
}
    
struct BibleCell: View {
    var bible: Bible
    
    var body: some View {
        HStack(alignment: .center) {
            Image(bible.imageName)
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 60, height: 60)
                .cornerRadius(4)
                .padding(.trailing)
                .padding(.vertical, 4)
                
            VStack(alignment: .leading, spacing: 6) {
        Text(bible.title)
            .fontWeight(.semibold)
            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            .minimumScaleFactor(0.5)
            
            
//        Text(bible.dueDate)
//            .font(.subheadline)
//            .foregroundColor(.secondary)
            }
        }
    }
}

struct CalendarPage_Previews: PreviewProvider {
    static var previews: some View {
        CalendarList()
    }
}
