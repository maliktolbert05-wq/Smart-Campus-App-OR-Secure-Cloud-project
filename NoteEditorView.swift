//
//  NoteEditorView.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import SwiftUI
import FirebaseFirestore

struct NoteEditorView: View {
    @State var note: Note
    let subject: Subject
    let isNew: Bool
    @State private var showingAI = false
    @Environment(\.dismiss) var dismiss
    private let db = Firestore.firestore()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("Title", text: $note.title)
                .font(.title2.bold())
                .padding([.horizontal, .top])

            Divider().padding(.top, 8)

            TextEditor(text: $note.content)
                .padding(.horizontal, 12)
        }
        .navigationTitle(subject.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingAI = true } label: {
                    Label("AI Help", systemImage: "sparkles")
                        .foregroundColor(.purple)
                }
            }
        }
        .sheet(isPresented: $showingAI) {
            AIHelperView(noteTitle: note.title, noteContent: note.content)
        }
        .onDisappear(perform: save)
    }

    func save() {
        note.dateModified = Date()
        if isNew {
            try? db.collection("notes").addDocument(from: note)
        } else if let id = note.id {
            try? db.collection("notes").document(id).setData(from: note)
        }
    }
}
