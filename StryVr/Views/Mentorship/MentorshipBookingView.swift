import SwiftUI

struct MentorshipBookingView: View {
    @State private var selectedMentor: Mentor?
    @State private var selectedDate: String = ""
    @State private var isBookingConfirmed = false
    
    let mentors: [Mentor] = [
        Mentor(id: "1", name: "Jane Doe", expertise: "Business Strategy", availableDates: ["2024-03-10", "2024-03-15"], profileImageURL: "https://example.com/jane.jpg"),
        Mentor(id: "2", name: "John Smith", expertise: "Tech Leadership", availableDates: ["2024-03-12", "2024-03-18"], profileImageURL: "https://example.com/john.jpg")
    ]

    var body: some View {
        VStack {
            Text("Book a Mentor")
                .font(.largeTitle)
                .bold()
                .padding()

            List(mentors) { mentor in
                HStack {
                    AsyncImage(url: URL(string: mentor.profileImageURL)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(mentor.name).font(.headline)
                        Text(mentor.expertise).font(.subheadline).foregroundColor(.gray)
                    }

                    Spacer()

                    Button("Select") {
                        selectedMentor = mentor
                    }
                    .buttonStyle(.bordered)
                }
            }

            if let mentor = selectedMentor {
                Text("Selected Mentor: \(mentor.name)").bold().padding()

                Picker("Select Date", selection: $selectedDate) {
                    ForEach(mentor.availableDates, id: \.self) { date in
                        Text(date)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                Button("Confirm Booking") {
                    isBookingConfirmed = true
                    // TODO: Send to Firestore
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }

            if isBookingConfirmed {
                Text("Booking Confirmed!")
                    .foregroundColor(.green)
                    .bold()
                    .padding()
            }
        }
        .padding()
    }
}

