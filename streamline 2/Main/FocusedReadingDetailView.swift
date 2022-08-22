//
//  FocusedReadingDetailView.swift
//  streamline
//
//  Created by Matt Forgacs on 8/2/21.
//

import SwiftUI

struct FocusedReadingDetailView: View {
    var bible: Bible
        
    var body: some View {
        VStack(spacing: 30) {
                Spacer()
                Image(bible.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .cornerRadius(12)

            Text(bible.title)
                .fontWeight(.semibold)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack {
                Label("\(bible.viewCount)", systemImage: "eye")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(bible.uploadDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
            }

            Text(bible.description)
                .font(.body)
                .padding(.leading, 50)
                .padding(.trailing, 50)

            Spacer()

            Link(destination: bible.url, label: {
                Text("Read in Bible")
                    .bold()
                    .font(.title2)
                    .frame(width: 200, height: 50)
                    .background(Color(.systemOrange))
                    .foregroundColor(.white)
                    .cornerRadius(10)
    
            }) .padding()
            Spacer()
        }
    }
}

struct FocusedReadingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FocusedReadingDetailView(bible: BibleList.upcomingReadings.first!)
    }
}
