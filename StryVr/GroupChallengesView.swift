//
//  GroupChallengesView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/7/25.
//
import SwiftUI

class GroupChallengesViewModel: ObservableObject {
    @Published var challenges = ["Hackathon", "AI Challenge", "Startup Pitch"]
}

struct GroupChallengesView: View {
    @StateObject private var viewModel = GroupChallengesViewModel()

    var body: some View {
        List(viewModel.challenges, id: \.self) { challenge in
            Text(challenge)
                .padding()
                .accessibilityLabel("\(challenge) Challenge")
        }
        .navigationTitle("Group Challenges")
        .accessibilityLabel("Group Challenges Title")
    }
}

struct GroupChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChallengesView()
    }
}
