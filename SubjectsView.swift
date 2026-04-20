//
//  SubjectsView.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SubjectsView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var subjects: [Subject] = []
    @State private var showingAdd = false
    @State private var newName = ""
    @State private var newTeacher = ""
    @State private var selectedColor = "blue"
    private let db = Firestore.firestore()
    let colors = ["blue", "red", "green", "orange", "purple", "pink", "teal"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(subjects) { subject in
                    NavigationLink(destination: NotesListView(subject: subject)) {
                        HStack(spacing: 14) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(color(subject.colorName))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Text(String(subject.name.prefix(1)))
                                        .foregroundColor(.white)
                                        .font(.title3.bold())
                                )
                            VStack(alignment: .leading, spacing: 2) {
                                Text(subject.name).font(.headline)
                                if !subject.teacher.isEmpty {
                                    Text(subject.teacher).font(.caption).foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteSubject)
            }
            .navigationTitle("My Classes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: { Image(systemName: "plus") }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") { auth.signOut() }.foregroundColor(.red)
                }
            }
            .sheet(isPresented: $showingAdd) { addSheet }
            .onAppear(perform: fetch)
        }
    }

    var addSheet: some View {
        NavigationStack {
            Form {
                Section("Class Info") {
                    TextField("Class name (e.g. Biology 101)", text: $newName)
                    TextField("Teacher name (optional)", text: $newTeacher)
                }
                Section("Color") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(colors, id: \.self) { c in
                                Circle()
                                    .fill(color(c))
                                    .frame(width: 36, height: 36)
                                    .overlay(Circle().stroke(Color.primary.opacity(selectedColor == c ? 1 : 0), lineWidth: 3))
                                    .onTapGesture { selectedColor = c }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Add Class")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showingAdd = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { addSubject(); showingAdd = false }
                        .disabled(newName.isEmpty)
                }
            }
        }
    }

    func color(_ name: String) -> Color {
        switch name {
        case "red": return .red
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "teal": return .teal
        default: return .blue
        }
    }

    func fetch() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("subjects").whereField("userId", isEqualTo: uid)
            .order(by: "dateCreated")
            .addSnapshotListener { snap, _ in
                subjects = snap?.documents.compactMap { try? $0.data(as: Subject.self) } ?? []
            }
    }

    func addSubject() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let s = Subject(name: newName, teacher: newTeacher, colorName: selectedColor, userId: uid, dateCreated: Date())
        try? db.collection("subjects").addDocument(from: s)
        newName = ""; newTeacher = ""; selectedColor = "blue"
    }

    func deleteSubject(at offsets: IndexSet) {
        offsets.forEach { if let id = subjects[$0].id { db.collection("subjects").document(id).delete() } }
    }
}
