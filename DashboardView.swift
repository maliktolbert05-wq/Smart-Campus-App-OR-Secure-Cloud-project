//
//  DashboardView.swift
//  SmartCampusApp
//
//  Created by Malik Tolbert on 4/3/26.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    // Defines a 2-column flexible grid
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // 1. Welcome Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome back,")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Malik")
                                .font(.largeTitle.bold())
                        }
                        Spacer()
                        Button(action: { auth.signOut() }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.title3)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }

                    // 2. Bento Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        // Large "Featured" Card (e.g., Next Class)
                        DashboardCard(
                            title: "Next Class",
                            subtitle: "Discrete Math\n1:00 PM - RM 302",
                            icon: "timer",
                            color: .blue,
                            isLarge: true
                        )
                        
                        // Small Action Cards
                        DashboardCard(title: "Schedule", icon: "calendar", color: .purple)
                        DashboardCard(title: "Grades", icon: "chart.bar.fill", color: .orange)
                        DashboardCard(title: "Campus Map", icon: "map.fill", color: .green)
                        DashboardCard(title: "Notes", icon: "doc.text.fill", color: .cyan)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
            .navigationBarHidden(true)
        }
    }
}

// 3. The Reusable Bento Card Component
struct DashboardCard: View {
    var title: String
    var subtitle: String? = nil
    var icon: String
    var color: Color
    var isLarge: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.8))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: isLarge ? 200 : 130) // Large cards are taller
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(color.gradient) // Native iOS 16+ gradients
        )
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    DashboardView().environmentObject(AuthViewModel())
}
