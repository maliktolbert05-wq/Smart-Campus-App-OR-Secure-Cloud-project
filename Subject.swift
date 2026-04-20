//
//  Subject.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import Foundation
import FirebaseFirestore

struct Subject: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var teacher: String
    var colorName: String
    var userId: String
    var dateCreated: Date
}
