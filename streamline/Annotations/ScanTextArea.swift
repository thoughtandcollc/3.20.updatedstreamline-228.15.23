//
//  ScanTextArea.swift
//  streamline
//
//  Created by Matt on 6/20/22.
//

import SwiftUI

struct ScanTextArea: View {
    @State var captionScan: String = ""
    
    var body: some View {
        VStack {
            Text("Scan Here")
                .font(.title3)
                .foregroundColor(Color("AdaptiveColor"))
            Divider()
            
            HStack {
                TextArea("Click here to open the prompt to begin scanning. Highlight and copy the material. Hit the back button, and paste in the regular new post area.", text: $captionScan)
            } .padding()
            
            Spacer()
        } .padding()
    }
}

struct ScanTextArea_Previews: PreviewProvider {
    static var previews: some View {
        ScanTextArea()
    }
}
