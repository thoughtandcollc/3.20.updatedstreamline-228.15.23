//
//  ReadingsViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 6/9/21.
//

import SwiftUI

class ReadingViewModel: ObservableObject {
    @Published var readings = [Reading]()
    
    init() {
        fetchReadings()
        
    }
    
    func fetchReadings() {
        COLLECTION_READINGS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.readings = documents.map({ Reading(dictionary: $0.data()) })
            self.readings = self.readings.sorted(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
        }
    }
//    func fetchReplies() {
//        COLLECTION_REPLIES.getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            self.readings = documents.map({ Reading(dictionary: $0.data()) })
//            self.readings = self.readings.sorted(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
//    }
//}
}
