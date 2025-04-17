//
//  CustomNavigationView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//  🧭 Themed Custom Navigation Entry Point for Dynamic Routing
//

import SwiftUI

struct CustomNavigationView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                VStack(spacing: Theme.Spacing.large) {
                    Spacer()

                    Text("StryVr Navigation")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityLabel("StryVr Navigation Title")
                        .accessibilityHint("Displays the main navigation entry point")

                    NavigationLink(destination: PlaceholderView()) {
                        Text("Go to Next Screen")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.whiteText)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.Colors.accent)
                            .cornerRadius(Theme.CornerRadius.medium)
                            .accessibilityLabel("Go to next screen")
                            .accessibilityHint("Navigates to the next screen")
                    }
                    .padding(.horizontal, Theme.Spacing.large)

                    Spacer()
                }
            }
            .navigationTitle("Navigation")
        }
    }
}

struct PlaceholderView: View {
    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()
            Text("🧭 Next Screen Content")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)
                .accessibilityLabel("Next screen content placeholder")
        }
    }
}

#Preview {
    CustomNavigationView()
}
