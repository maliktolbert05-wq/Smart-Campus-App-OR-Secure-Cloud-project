//
//  Note.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import Foundation
import FirebaseFirestore

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var subjectId: String
    var subjectName: String
    var dateCreated: Date
    var dateModified: Date
    var userId: String
}
