import SwiftUI

/// Displays user profile details
struct ProfileView: View {
    var user: UserModel
    
    var body: some View {
        VStack {
            if let urlString = user.profileImageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }
            
            Text(user.fullName)
                .font(.title)
                .bold()
            
            Text(user.bio ?? "No bio available")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
