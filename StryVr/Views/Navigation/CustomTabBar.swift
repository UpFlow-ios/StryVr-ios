import SwiftUI

/// Custom tab bar navigation
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    private let tabItems = [
        ("house.fill", "Home", 0),
        ("person.fill", "Profile", 1)
    ]
    
    var body: some View {
        HStack {
            ForEach(tabItems, id: \.2) { item in
                Button(action: { selectedTab = item.2 }) {
                    Image(systemName: item.0)
                        .accessibility(label: Text(item.1))
                }
                if item != tabItems.last {
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(Capsule())
    }
}
