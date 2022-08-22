//
//  EditListView.swift
//  streamline
//
//  Created by Matt Forgacs on 9/14/21.
//

//import SwiftUI
//
//struct EditListView: View {
//    @State private var usedNotes = [String]()
//    @State private var rootNote = ""
//    @State private var newNote = ""
//
//
//    var body: some View {
//        NavigationView {
//            VStack {
//
//                Text("Class Notes")
//                    .font(.headline)
//                    .foregroundColor(Color.orange)
//
//
//
//                TextField("Enter New Note", text: $newNote, onCommit: addnewNote)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .autocapitalization(.sentences)
//                    .padding()
//
//
//                List(usedNotes, id: \.self) {
//                    Text($0)
//                        .bold()
//                }
//            }
//            .navigationBarTitle(rootNote)
//        }
//    }
//    func addnewNote() {
//        let answer =
//            newNote.lowercased()
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//
//        guard answer.count > 0 else {
//            return
//        }
//
//        usedNotes.append(answer)
//        newNote = ""
//    }
//}
//
//struct EditListView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditListView()
//    }
//}
