//
//  ReplyCell.swift
//  streamline
//
//  Created by Matt Forgacs on 6/1/21.
//

import SwiftUI

struct ReplyCell: View {
    
    
    var body: some View {
     
        NavigationLink(
        destination: Report(),
        label: {
            Image(systemName: "flag")
        })
        
    }
}
