//
//  SmartCampusAppApp.swift
//  SmartCampusApp
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
@main
struct SmartCampusAppApp: App {
    init() {
        FirebaseApp.configure()
    }

    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            // We are forcing LoginView to show regardless of the auth state
            LoginView()
                    .environmentObject(authViewModel)
                    .onOpenURL { url in
                        // This handles the "return trip" after Google login
                        GIDSignIn.sharedInstance.handle(url)
                    }
            }
        }
    }

