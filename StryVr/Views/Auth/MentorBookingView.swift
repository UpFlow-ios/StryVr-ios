//
//  MentorBookingView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//
import SwiftUI

class MentorBookingViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var isBooking = false

    func bookSession() {
        isBooking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isBooking = false
        }
    }
}

struct MentorBookingView: View {
    @StateObject private var viewModel = MentorBookingViewModel()

    var body: some View {
        VStack {
            Text("Book a Mentor Session")
                .font(.title)
                .fontWeight(.bold)
                .accessibilityLabel("Book a Mentor Session Title")

            DatePicker("Select Date & Time", selection: $viewModel.selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                .accessibilityLabel("Select Date & Time DatePicker")

            Button(action: viewModel.bookSession) {
                Text("Confirm Booking")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .accessibilityLabel("Confirm Booking Button")
            }
            .padding()

            if viewModel.isBooking {
                ProgressView("Booking Session...")
                    .padding()
                    .accessibilityLabel("Booking Session ProgressView")
            }
        }
        .padding()
    }
}

struct MentorBookingView_Previews: PreviewProvider {
    static var previews: some View {
        MentorBookingView()
    }
}
