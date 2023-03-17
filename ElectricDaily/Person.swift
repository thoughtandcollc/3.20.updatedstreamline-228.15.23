//
//  Person.swift
//  streamline
//
//  Created by Matt on 10/4/22.
//

import Foundation
import SwiftUI

struct Person: Hashable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var imageURLS: [URL]
    var bio: String
    var distance: Int
  //  var bioLong: String
    var age: String
    
    // card
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var degree: Double = 0.0
    
}
