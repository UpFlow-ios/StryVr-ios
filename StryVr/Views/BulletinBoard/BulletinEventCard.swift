import SwiftUI

struct BulletinEventCard: View {
    let event: BulletinEvent
    @State private var isRSVPed = false
    @State private var showingEventDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with date and time
            eventHeader
            
            // Event details
            eventContent
            
            // RSVP and actions
            eventActions
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(eventBorderColor, lineWidth: 2)
        )
        .shadow(color: eventShadowColor, radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Header
    private var eventHeader: some View {
        HStack(spacing: 12) {
            // Date Block
            VStack(spacing: 2) {
                Text(monthString)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Text(dayString)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(width: 50, height: 50)
            .background(.green)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(timeString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: event.isVirtual ? "video" : "location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.location)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Quick RSVP indicator
            if event.isRSVPRequired {
                VStack(spacing: 4) {
                    Image(systemName: isRSVPed ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isRSVPed ? .green : .secondary)
                    
                    Text("RSVP")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    // MARK: - Content
    private var eventContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Description
            if !event.description.isEmpty {
                Text(event.description)
                    .font(.body)
                    .lineLimit(3)
                    .padding(.horizontal, 16)
            }
            
            // Event details
            VStack(alignment: .leading, spacing: 8) {
                if !event.organizer.isEmpty {
                    HStack {
                        Image(systemName: "person.circle")
                            .foregroundColor(.blue)
                        Text("Organized by \(event.organizer)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if event.maxAttendees != nil {
                    HStack {
                        Image(systemName: "person.2")
                            .foregroundColor(.blue)
                        Text("\(event.currentAttendees)/\(event.maxAttendees!) attending")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        // Attendance progress
                        if let maxAttendees = event.maxAttendees {
                            ProgressView(value: Double(event.currentAttendees), total: Double(maxAttendees))
                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                .frame(width: 60)
                        }
                    }
                }
                
                if event.isVirtual && event.meetingLink != nil {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                        Text("Virtual meeting link available")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Tags
            if !event.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(event.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.green.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.bottom, 12)
    }
    
    // MARK: - Actions
    private var eventActions: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.horizontal, 16)
            
            HStack(spacing: 16) {
                // RSVP Button
                if event.isRSVPRequired {
                    Button(action: toggleRSVP) {
                        HStack(spacing: 6) {
                            Image(systemName: isRSVPed ? "checkmark.circle.fill" : "plus.circle")
                            Text(isRSVPed ? "Going" : "RSVP")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isRSVPed ? .green : .blue)
                        .cornerRadius(20)
                    }
                } else {
                    Button(action: { showingEventDetails = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle")
                            Text("Details")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.blue.opacity(0.1))
                        .cornerRadius(20)
                    }
                }
                
                // Add to Calendar
                Button(action: addToCalendar) {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar.badge.plus")
                        Text("Add to Calendar")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(20)
                }
                
                Spacer()
                
                // Share
                Button(action: shareEvent) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .sheet(isPresented: $showingEventDetails) {
            EventDetailsView(event: event)
        }
    }
    
    // MARK: - Computed Properties
    private var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: event.startDate).uppercased()
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: event.startDate)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let startTime = formatter.string(from: event.startDate)
        let endTime = formatter.string(from: event.endDate)
        return "\(startTime) - \(endTime)"
    }
    
    private var eventBorderColor: Color {
        if isUpcoming {
            return .green
        } else if isToday {
            return .orange
        } else {
            return .gray.opacity(0.3)
        }
    }
    
    private var eventShadowColor: Color {
        if isUpcoming {
            return .green.opacity(0.3)
        } else if isToday {
            return .orange.opacity(0.3)
        } else {
            return .black.opacity(0.1)
        }
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(event.startDate)
    }
    
    private var isUpcoming: Bool {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        return event.startDate >= tomorrow && event.startDate <= nextWeek
    }
    
    // MARK: - Actions
    private func toggleRSVP() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isRSVPed.toggle()
        }
        
        // TODO: Call service to update RSVP
        Task {
            // await bulletinService.rsvpToEvent(event.id, companyId: event.companyId, attending: isRSVPed)
        }
    }
    
    private func addToCalendar() {
        // TODO: Implement add to calendar functionality
        print("Add to calendar: \(event.title)")
    }
    
    private func shareEvent() {
        // TODO: Implement sharing functionality
        print("Share event: \(event.title)")
    }
}

// MARK: - Event Details Sheet
struct EventDetailsView: View {
    let event: BulletinEvent
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Organized by \(event.organizer)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Date and Time
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Date & Time", systemImage: "calendar")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.startDate, style: .date)
                                .font(.body)
                            Text("\(event.startDate, style: .time) - \(event.endDate, style: .time)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Location", systemImage: event.isVirtual ? "video" : "location")
                            .font(.headline)
                        
                        Text(event.location)
                            .font(.body)
                        
                        if event.isVirtual, let meetingLink = event.meetingLink {
                            Link("Join Meeting", destination: URL(string: meetingLink)!)
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Description
                    if !event.description.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Description", systemImage: "text.alignleft")
                                .font(.headline)
                            
                            Text(event.description)
                                .font(.body)
                        }
                    }
                    
                    // Attendance
                    if event.maxAttendees != nil {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Attendance", systemImage: "person.2")
                                .font(.headline)
                            
                            HStack {
                                Text("\(event.currentAttendees) of \(event.maxAttendees!) people attending")
                                    .font(.body)
                                
                                Spacer()
                                
                                if let maxAttendees = event.maxAttendees {
                                    ProgressView(value: Double(event.currentAttendees), total: Double(maxAttendees))
                                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                        .frame(width: 100)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        BulletinEventCard(event: BulletinEvent(
            title: "All-Hands Meeting",
            description: "Monthly company update with Q4 results and Q1 planning",
            startDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date().addingTimeInterval(3600)) ?? Date(),
            location: "Main Conference Room",
            isVirtual: true,
            meetingLink: "https://zoom.us/j/123456789",
            organizer: "David Kim",
            maxAttendees: 200,
            currentAttendees: 45,
            isRSVPRequired: true,
            tags: ["all-hands", "quarterly"],
            companyId: "company_001"
        ))
        
        BulletinEventCard(event: BulletinEvent(
            title: "Holiday Party",
            description: "Annual company holiday celebration with dinner and entertainment",
            startDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 10, to: Date().addingTimeInterval(14400)) ?? Date(),
            location: "Grand Ballroom, Downtown Hotel",
            organizer: "Lisa Thompson",
            maxAttendees: 150,
            currentAttendees: 89,
            isRSVPRequired: true,
            tags: ["holiday", "social"],
            companyId: "company_001"
        ))
    }
    .padding()
    .background(ThemeManager.backgroundColor)
}
