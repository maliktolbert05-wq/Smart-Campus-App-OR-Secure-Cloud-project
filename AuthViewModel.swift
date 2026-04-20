//
//  Untitled.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import Foundation
import SwiftUI
import Combine
import FirebaseCore   // Required for FirebaseApp
import FirebaseAuth   // Required for Auth and User
import GoogleSignIn
import GoogleSignInSwift

class AuthViewModel: ObservableObject {
    // These must stay INSIDE the class braces
    @Published var user: User?
    @Published var isSignedIn = false

    init() {
        // We use FirebaseAuth's User type here
        self.user = Auth.auth().currentUser
        self.isSignedIn = user != nil
        
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.user = user
                self?.isSignedIn = user != nil
            }
        }
    }

    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Error: Firebase is not configured or ClientID is missing.")
            return
        }
        
        // Google SDK setup
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: root) { result, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            // Linking Google Credential to Firebase Auth
            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    print("Firebase Google sign-in error: \(error.localizedDescription)")
                }
            }
        }
    }

    func signInWithEmail(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error?.localizedDescription)
        }
    }

    func createAccount(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error?.localizedDescription)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
} // This is the ONLY closing brace for the class
