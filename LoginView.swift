//
//  LoginView.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            // 1. Background Layer - Using a clean system background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                // 2. Header / Branding
                VStack(spacing: 8) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 80))
                    // Clean gradient for a professional engineering look
                        .foregroundStyle(.linearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom))
                    
                    Text("SmartCampus")
                        .font(.largeTitle.bold())
                        .tracking(-1)
                    
                    Text("Your notes, organized.")
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // 3. Input Card - Now correctly calling your custom components
                VStack(spacing: 15) {
                    // ADDED THESE TWO LINES:
                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                    CustomSecureField(icon: "lock.fill", placeholder: "Password", text: $password)
                    
                    // Replace your current Google button with this logic
                    Button(action: {
                        auth.signInWithGoogle()
                    }) {
                        HStack {
                            Image("google_logo") // Make sure you have a small google logo in Assets
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign in with Google")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }
                    .padding(20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // 4. Social Login
                    HStack {
                        Rectangle().frame(height: 1).opacity(0.1)
                        Text("OR").font(.caption).bold().opacity(0.3)
                        Rectangle().frame(height: 1).opacity(0.1)
                    }
                    
                    GoogleSignInButton(scheme: .light, style: .wide, state: .normal) {
                        auth.signInWithGoogle()
                    }
                    .frame(height: 50)
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
        }
    }
    
    // MARK: - Reusable Components
    // Moved OUTSIDE of LoginView to fix the ViewBuilder error
    
    struct CustomTextField: View {
        var icon: String
        var placeholder: String
        @Binding var text: String
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 25)
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
            }
            .padding()
            .background(Color(.tertiarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
    
    struct CustomSecureField: View {
        var icon: String
        var placeholder: String
        @Binding var text: String
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 25)
                SecureField(placeholder, text: $text)
            }
            .padding()
            .background(Color(.tertiarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}
