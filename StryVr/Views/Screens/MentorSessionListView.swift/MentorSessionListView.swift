//
//  Untitled.swift
//  StryVr
//
//  Created by Joe Dormond on 2/24/25.
//
import SwiftUI

struct MentorSessionListView: View {
    @State private var sessions: [MentorSession] = [
        MentorSession(title: "SwiftUI Basics", mentor: "John Doe", date: "Feb 28, 2025"),
        MentorSession(title: "Firebase Deep Dive", mentor: "Alice Smith", date: "March 3, 2025")
    ]

    var body: some View {
        NavigationView {
            List(sessions) { session in
                MentorSessionCard(session: session)
            }
            .navigationTitle("Mentor Sessions")
        }
    }
}

struct MentorSession: Identifiable {
    let id = UUID()
    let title: String
    let mentor: String
    let date: String
}

struct MentorSessionCard: View {
    let session: MentorSession

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(session.title)
                    .font(.headline)
                Text("With \(session.mentor)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Date: \(session.date)")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemBackground)).shadow(radius: 2))
    }
}

struct MentorSessionListView_Previews: PreviewProvider {
    static var previews: some View {
        MentorSessionListView()
    }
}

