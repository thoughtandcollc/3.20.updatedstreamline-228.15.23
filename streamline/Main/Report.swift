//
//  Report.swift
//  streamline
//
//  Created by Matt Forgacs on 9/1/21.
//

import SwiftUI

struct Report: View {
    var body: some View {
        
        NavigationView {
            VStack {
                NavigationLink(
                    destination: SettingsPage(),
                    label: {
                Text("Report this Post")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                    })

            Divider()
         
                NavigationLink(
                    destination: SettingsPage(),
                    label: {
                        Text("Block this User")
                            .font(.title)
                            .fontWeight(.bold)
                    })
                

            Divider()
                Spacer()
            }
        }
    }
}
struct Report_Previews: PreviewProvider {
    static var previews: some View {
        Report()
    }
}
