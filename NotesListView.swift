//
//  NotesListView.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NotesListView: View {
    let subject: Subject
    @State private var notes: [Note] = []
    private let db = Firestore.firestore()

    var blankNote: Note {
        Note(title: "", content: "",
             subjectId: subject.id ?? "",
             subjectName: subject.name,
             dateCreated: Date(), dateModified: Date(),
             userId: Auth.auth().currentUser?.uid ?? "")
    }

    var body: some View {
        List {
            ForEach(notes) { note in
                NavigationLink(destination: NoteEditorView(note: note, subject: subject, isNew: false)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title.isEmpty ? "Untitled Note" : note.title).font(.headline)
                        if !note.content.isEmpty {
                            Text(note.content.prefix(80))
                                .font(.caption).foregroundColor(.secondary).lineLimit(2)
                        }
                        Text(note.dateModified, style: .relative)
                            .font(.caption2).foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete(perform: deleteNote)
        }
        .navigationTitle(subject.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: NoteEditorView(note: blankNote, subject: subject, isNew: true)) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .onAppear(perform: fetch)
    }

    func fetch() {
        guard let uid = Auth.auth().currentUser?.uid, let sid = subject.id else { return }
        db.collection("notes")
            .whereField("userId", isEqualTo: uid)
            .whereField("subjectId", isEqualTo: sid)
            .order(by: "dateModified", descending: true)
            .addSnapshotListener { snap, _ in
                notes = snap?.documents.compactMap { try? $0.data(as: Note.self) } ?? []
            }
    }

    func deleteNote(at offsets: IndexSet) {
        offsets.forEach { if let id = notes[$0].id { db.collection("notes").document(id).delete() } }
    }
}
