//
//  String+Ext.swift
//  streamline
//
//  Created by Tayyab Ali on 26/02/2022.
//

import Foundation

extension String {
    var byWords: [SubSequence] {
        self.split(separator: " ")
    }
    
    mutating func removeWordFromString(wordToRemove: String) {
        self = String(self.trimmingCharacters(in: .whitespacesAndNewlines).dropLast(wordToRemove.count))
    }
    
    mutating func insert(_ string: String, index: Int) {
      self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: index) )
    }
}
