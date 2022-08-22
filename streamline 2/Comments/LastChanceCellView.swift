//
//  LastChance.swift
//  streamline
//
//  Created by Matt Forgacs on 10/5/21.
//

import SwiftUI

struct LastChanceCellView: View {
    @ObservedObject var viewModel = MarginViewModel()
  //  let margin: Margin
   // let reading: Reading
    
var body: some View {
//    ZStack(alignment: .bottomTrailing) {
        ScrollView {
            VStack {
                ForEach(viewModel.margin) { margin in
                    LastChanceCell(margin: margin)
                    } .padding()
                }
            }
        }
    }    
//struct LastChance_Previews: PreviewProvider {
//    static var previews: some View {
//        LastChanceCellView()
//    }
//}
