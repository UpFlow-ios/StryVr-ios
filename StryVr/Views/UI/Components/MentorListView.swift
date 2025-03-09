//
// import SwiftUI

struct MentorListView: View {
    let mentors: [Mentor]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(mentors) { mentor in
                    VStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                        Text(mentor.name)
                            .font(.headline)
                        Text(mentor.expertise.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 150)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                }
            }
            .padding()
        }
    }
}
 Untitled.swift
//  StryVr
//
//  Created by Joe Dormond on 2/24/25.
//

