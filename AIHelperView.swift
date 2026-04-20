//
//  AIHelperView.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import SwiftUI

struct AIHelperView: View {
    let noteTitle: String
    let noteContent: String
    @State private var question = ""
    @State private var response = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                if !noteTitle.isEmpty {
                    Text("Using context from: \(noteTitle)")
                        .font(.caption).foregroundColor(.secondary).padding(.horizontal)
                }

                HStack {
                    TextField("Ask anything about your notes or homework...", text: $question)
                        .textFieldStyle(.roundedBorder)
                    Button(action: ask) {
                        Image(systemName: isLoading ? "ellipsis" : "paperplane.fill")
                            .foregroundColor(.white).padding(10)
                            .background(question.isEmpty ? Color.gray : Color.purple)
                            .cornerRadius(10)
                    }
                    .disabled(question.isEmpty || isLoading)
                }
                .padding(.horizontal)

                if isLoading {
                    HStack { Spacer(); ProgressView("Thinking..."); Spacer() }
                }

                if !response.isEmpty {
                    ScrollView {
                        Text(response)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("✨ AI Homework Helper")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    func ask() {
        isLoading = true
        response = ""

        let context = noteContent.isEmpty ? "" : "Student's notes on '\(noteTitle)':\n\(noteContent)\n\n"
        let fullMessage = "\(context)Question: \(question)"

        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("YOUR_ANTHROPIC_API_KEY", forHTTPHeaderField: "x-api-key") // ⚠️ see note below
        req.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let body: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 1024,
            "system": "You are a friendly and clear student tutor. Help students understand their notes and homework. Be concise and educational.",
            "messages": [["role": "user", "content": fullMessage]]
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: req) { data, _, _ in
            DispatchQueue.main.async {
                isLoading = false
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let content = json["content"] as? [[String: Any]],
                      let text = content.first?["text"] as? String else {
                    response = "Something went wrong. Please try again."
                    return
                }
                response = text
                question = ""
            }
        }.resume()
    }
}
