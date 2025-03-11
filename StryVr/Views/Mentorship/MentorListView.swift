//  StryVr
//
//  Created by Joe Dormond on 2/24/25.
//
//
//import SwiftUI

/// Displays a list of available mentors in StryVr
struct MentorListView: View {
    /// List of mentors to display
    var mentors: [MentorModel]
    
    var body: some View {
        List(mentors) { mentor in
            HStack {
                if let urlString = mentor.profileImageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Circle().fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                }

                VStack(alignment: .leading) {
                    Text(mentor.fullName)
                        .font(.headline)
                    Text(mentor.expertise.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
