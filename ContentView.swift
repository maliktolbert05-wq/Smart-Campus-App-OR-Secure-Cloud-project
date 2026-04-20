//
//  ContentView.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        if auth.isSignedIn {
            SubjectsView()
        } else {
            LoginView()
        }
    }
}
