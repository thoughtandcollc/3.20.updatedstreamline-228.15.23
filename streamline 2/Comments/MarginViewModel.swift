//
//  MarginViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 10/5/21.
//

import SwiftUI
import Firebase

class MarginViewModel: ObservableObject {
    @Published var margin = [Margin]()

    init() {
        fetchMargin()

    }

    func fetchMargin() {
        COLLECTION_MARGIN.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.margin = documents.map({ Margin(dictionary: $0.data()) })
            self.margin = self.margin.sorted(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
        }
    }
}
