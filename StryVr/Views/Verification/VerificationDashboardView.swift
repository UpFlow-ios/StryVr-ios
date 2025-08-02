//
//  VerificationDashboardView.swift
//  StryVr
//
//  🔐 Verification Dashboard View – Comprehensive verification status and management
//  Integrates with ClearMe and other verification services for transparency and trust
//

import SwiftUI

struct VerificationDashboardView: View {
    @StateObject private var verificationService = VerificationService()
    @State private var selectedVerificationType: VerificationType?
    @State private var showingVerificationSheet = false
    @State private var showingClearMeVerification = false
    @State private var isLoading = false
    
    let userID: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // Verification Summary Card
                    verificationSummaryCard
                    
                    // Verification Types Grid
                    verificationTypesGrid
                    
                    // Active Verifications List
                    activeVerificationsList
                    
                    // Verification Providers
                    verificationProvidersSection
                }
                .padding()
            }
            .background(Theme.Colors.background)
            .navigationTitle("Verification Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingVerificationSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.Colors.primary)
                    }
                }
            }
        }
        .onAppear {
            loadVerifications()
        }
        .sheet(isPresented: $showingVerificationSheet) {
            NewVerificationView(verificationService: verificationService, userID: userID)
        }
        .sheet(isPresented: $showingClearMeVerification) {
            ClearMeVerificationView(verificationService: verificationService, userID: userID)
        }
    }
    
    // MARK: - Verification Summary Card
    
    private var verificationSummaryCard: some View {
        let summary = verificationService.getVerificationSummary(userID: userID)
        
        return VStack(spacing: Theme.Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("Verification Status")
                        .font(Theme.Fonts.headline)
                        .foregroundColor(Theme.Colors.text)
                    
                    Text("Level: \(summary.verificationLevel)")
                        .font(Theme.Fonts.subheadline)
                        .foregroundColor(Theme.Colors.primary)
                }
                
                Spacer()
                
                // Verification Badge
                VStack {
                    Image(systemName: summary.isFullyVerified ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                        .font(.title)
                        .foregroundColor(summary.isFullyVerified ? .green : .orange)
                    
                    Text(summary.isFullyVerified ? "Verified" : "In Progress")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(summary.isFullyVerified ? .green : .orange)
                }
            }
            
            // Progress Bar
            ProgressView(value: summary.completionRate)
                .progressViewStyle(LinearProgressViewStyle(tint: Theme.Colors.primary))
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            // Stats Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: Theme.Spacing.medium) {
                StatCard(title: "Approved", value: "\(summary.approvedVerifications)", color: .green)
                StatCard(title: "Pending", value: "\(summary.pendingVerifications)", color: .orange)
                StatCard(title: "Total", value: "\(summary.totalVerifications)", color: .blue)
                StatCard(title: "Score", value: String(format: "%.1f", summary.averageScore * 100), color: .purple)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(Theme.Spacing.medium)
    }
    
    // MARK: - Verification Types Grid
    
    private var verificationTypesGrid: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Verification Types")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: Theme.Spacing.medium) {
                ForEach(VerificationType.allCases, id: \.self) { verificationType in
                    VerificationTypeCard(
                        verificationType: verificationType,
                        isVerified: isVerificationTypeApproved(verificationType),
                        action: {
                            selectedVerificationType = verificationType
                            showingVerificationSheet = true
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Active Verifications List
    
    private var activeVerificationsList: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Active Verifications")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)
            
            if verificationService.userVerifications.isEmpty {
                EmptyVerificationsView()
            } else {
                ForEach(verificationService.userVerifications.filter { $0.userID == userID }) { verification in
                    VerificationCard(verification: verification)
                }
            }
        }
    }
    
    // MARK: - Verification Providers Section
    
    private var verificationProvidersSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Trusted Verification Providers")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.medium) {
                    ForEach(VerificationProvider.allCases.filter { $0.isTrusted }, id: \.self) { provider in
                        VerificationProviderCard(provider: provider)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadVerifications() {
        Task {
            do {
                try await verificationService.loadUserVerifications(userID: userID)
            } catch {
                print("Error loading verifications: \(error)")
            }
        }
    }
    
    private func isVerificationTypeApproved(_ type: VerificationType) -> Bool {
        return verificationService.userVerifications.contains { verification in
            verification.userID == userID && 
            verification.verificationType == type && 
            verification.isVerified
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text(value)
                .font(Theme.Fonts.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(Theme.Spacing.small)
    }
}

struct VerificationTypeCard: View {
    let verificationType: VerificationType
    let isVerified: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.small) {
                HStack {
                    Image(systemName: verificationType.iconName)
                        .font(.title2)
                        .foregroundColor(isVerified ? .green : Theme.Colors.primary)
                    
                    Spacer()
                    
                    if isVerified {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Text(verificationType.rawValue)
                    .font(Theme.Fonts.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Colors.text)
                    .multilineTextAlignment(.leading)
                
                Text(verificationType.description)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .cornerRadius(Theme.Spacing.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct VerificationCard: View {
    let verification: UserVerificationModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text(verification.verificationType.rawValue)
                        .font(Theme.Fonts.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.Colors.text)
                    
                    Text(verification.verificationProvider.rawValue)
                        .font(Theme.Fonts.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: Theme.Spacing.small) {
                    StatusBadge(status: verification.status)
                    
                    if let score = verification.verificationScore {
                        Text("\(Int(score * 100))%")
                            .font(Theme.Fonts.caption)
                            .foregroundColor(Theme.Colors.primary)
                    }
                }
            }
            
            if let notes = verification.notes {
                Text(notes)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(2)
            }
            
            HStack {
                Text(verification.requestDate, style: .date)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Spacer()
                
                if let expirationDate = verification.expirationDate {
                    Text("Expires: \(expirationDate, style: .date)")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(verification.isExpired ? .red : Theme.Colors.textSecondary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(Theme.Spacing.medium)
    }
}

struct StatusBadge: View {
    let status: VerificationStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(Theme.Fonts.caption)
            .fontWeight(.medium)
            .padding(.horizontal, Theme.Spacing.small)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(8)
    }
    
    private var statusColor: Color {
        switch status {
        case .pending: return .gray
        case .inProgress: return .blue
        case .underReview: return .orange
        case .approved: return .green
        case .rejected: return .red
        case .expired: return .yellow
        case .cancelled: return .gray
        }
    }
}

struct VerificationProviderCard: View {
    let provider: VerificationProvider
    
    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            if let logoURL = provider.logoURL {
                AsyncImage(url: URL(string: logoURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.Colors.primary.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text(provider.rawValue.prefix(2))
                                .font(Theme.Fonts.headline)
                                .foregroundColor(Theme.Colors.primary)
                        )
                }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Theme.Colors.primary.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(provider.rawValue.prefix(2))
                            .font(Theme.Fonts.headline)
                            .foregroundColor(Theme.Colors.primary)
                    )
            }
            
            Text(provider.rawValue)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.text)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(Theme.Spacing.medium)
    }
}

struct EmptyVerificationsView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            Image(systemName: "checkmark.shield")
                .font(.system(size: 50))
                .foregroundColor(Theme.Colors.primary.opacity(0.5))
            
            Text("No Verifications Yet")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)
            
            Text("Start verifying your identity, employment, and skills to build trust with employers.")
                .font(Theme.Fonts.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(Theme.Spacing.medium)
    }
}

// MARK: - Preview

#Preview {
    VerificationDashboardView(userID: "preview_user")
} 