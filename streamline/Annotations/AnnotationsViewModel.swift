//
//  AnnotationsViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 9/13/21.
//

import SwiftUI
import Firebase

class AnnotationsViewModel: ObservableObject {
    @Published var annotate = [Annotate]()

    init() {
        fetchAnnotate()

    }

    func fetchAnnotate() {
        COLLECTION_ANNOTATE.addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.annotate = documents.map({ Annotate(dictionary: $0.data()) })
            self.annotate = self.annotate.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        }
    }
}
