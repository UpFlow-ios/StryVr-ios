import Foundation
import FirebaseFirestore

// MARK: - Bulletin Board Models

struct BulletinPost: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let type: BulletinPostType
    let authorId: String
    let authorName: String
    let authorRole: String
    let createdAt: Date
    let expiresAt: Date?
    let isSticky: Bool // Pin to top
    let isPriority: Bool // High priority posts
    let tags: [String]
    let attachments: [BulletinAttachment]
    let likes: Int
    let comments: Int
    let views: Int
    let companyId: String
    let departmentIds: [String] // Can target specific departments
    let visibility: BulletinVisibility
    
    init(
        id: String = UUID().uuidString,
        title: String,
        content: String,
        type: BulletinPostType,
        authorId: String,
        authorName: String,
        authorRole: String,
        createdAt: Date = Date(),
        expiresAt: Date? = nil,
        isSticky: Bool = false,
        isPriority: Bool = false,
        tags: [String] = [],
        attachments: [BulletinAttachment] = [],
        likes: Int = 0,
        comments: Int = 0,
        views: Int = 0,
        companyId: String,
        departmentIds: [String] = [],
        visibility: BulletinVisibility = .allEmployees
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.type = type
        self.authorId = authorId
        self.authorName = authorName
        self.authorRole = authorRole
        self.createdAt = createdAt
        self.expiresAt = expiresAt
        self.isSticky = isSticky
        self.isPriority = isPriority
        self.tags = tags
        self.attachments = attachments
        self.likes = likes
        self.comments = comments
        self.views = views
        self.companyId = companyId
        self.departmentIds = departmentIds
        self.visibility = visibility
    }
}

enum BulletinPostType: String, Codable, CaseIterable {
    case announcement = "announcement"
    case employeeRecognition = "employee_recognition"
    case event = "event"
    case milestone = "milestone"
    case policy = "policy"
    case training = "training"
    case socialEvent = "social_event"
    case wellness = "wellness"
    case safety = "safety"
    case achievement = "achievement"
    case news = "news"
    case reminder = "reminder"
    
    var displayName: String {
        switch self {
        case .announcement: return "Announcement"
        case .employeeRecognition: return "Employee Recognition"
        case .event: return "Event"
        case .milestone: return "Milestone"
        case .policy: return "Policy Update"
        case .training: return "Training"
        case .socialEvent: return "Social Event"
        case .wellness: return "Wellness"
        case .safety: return "Safety"
        case .achievement: return "Achievement"
        case .news: return "Company News"
        case .reminder: return "Reminder"
        }
    }
    
    var icon: String {
        switch self {
        case .announcement: return "megaphone.fill"
        case .employeeRecognition: return "star.fill"
        case .event: return "calendar"
        case .milestone: return "flag.fill"
        case .policy: return "doc.text.fill"
        case .training: return "graduationcap.fill"
        case .socialEvent: return "party.popper.fill"
        case .wellness: return "heart.fill"
        case .safety: return "shield.fill"
        case .achievement: return "trophy.fill"
        case .news: return "newspaper.fill"
        case .reminder: return "bell.fill"
        }
    }
    
    var color: String {
        switch self {
        case .announcement: return "blue"
        case .employeeRecognition: return "yellow"
        case .event: return "green"
        case .milestone: return "purple"
        case .policy: return "orange"
        case .training: return "indigo"
        case .socialEvent: return "pink"
        case .wellness: return "mint"
        case .safety: return "red"
        case .achievement: return "yellow"
        case .news: return "blue"
        case .reminder: return "gray"
        }
    }
}

enum BulletinVisibility: String, Codable {
    case allEmployees = "all_employees"
    case departmentOnly = "department_only"
    case managementOnly = "management_only"
    case executiveOnly = "executive_only"
    case specificRoles = "specific_roles"
    
    var displayName: String {
        switch self {
        case .allEmployees: return "All Employees"
        case .departmentOnly: return "Department Only"
        case .managementOnly: return "Management Only"
        case .executiveOnly: return "Executive Only"
        case .specificRoles: return "Specific Roles"
        }
    }
}

struct BulletinAttachment: Identifiable, Codable {
    let id: String
    let fileName: String
    let fileType: String
    let fileSize: Int
    let downloadUrl: String
    let thumbnailUrl: String?
    let uploadedAt: Date
    
    init(
        id: String = UUID().uuidString,
        fileName: String,
        fileType: String,
        fileSize: Int,
        downloadUrl: String,
        thumbnailUrl: String? = nil,
        uploadedAt: Date = Date()
    ) {
        self.id = id
        self.fileName = fileName
        self.fileType = fileType
        self.fileSize = fileSize
        self.downloadUrl = downloadUrl
        self.thumbnailUrl = thumbnailUrl
        self.uploadedAt = uploadedAt
    }
}

struct BulletinComment: Identifiable, Codable {
    let id: String
    let postId: String
    let authorId: String
    let authorName: String
    let authorRole: String
    let content: String
    let createdAt: Date
    let likes: Int
    let parentCommentId: String? // For replies
    
    init(
        id: String = UUID().uuidString,
        postId: String,
        authorId: String,
        authorName: String,
        authorRole: String,
        content: String,
        createdAt: Date = Date(),
        likes: Int = 0,
        parentCommentId: String? = nil
    ) {
        self.id = id
        self.postId = postId
        self.authorId = authorId
        self.authorName = authorName
        self.authorRole = authorRole
        self.content = content
        self.createdAt = createdAt
        self.likes = likes
        self.parentCommentId = parentCommentId
    }
}

struct BulletinEvent: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
    let location: String
    let isVirtual: Bool
    let meetingLink: String?
    let organizer: String
    let maxAttendees: Int?
    let currentAttendees: Int
    let isRSVPRequired: Bool
    let tags: [String]
    let companyId: String
    let departmentIds: [String]
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        startDate: Date,
        endDate: Date,
        location: String,
        isVirtual: Bool = false,
        meetingLink: String? = nil,
        organizer: String,
        maxAttendees: Int? = nil,
        currentAttendees: Int = 0,
        isRSVPRequired: Bool = false,
        tags: [String] = [],
        companyId: String,
        departmentIds: [String] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.isVirtual = isVirtual
        self.meetingLink = meetingLink
        self.organizer = organizer
        self.maxAttendees = maxAttendees
        self.currentAttendees = currentAttendees
        self.isRSVPRequired = isRSVPRequired
        self.tags = tags
        self.companyId = companyId
        self.departmentIds = departmentIds
    }
}

// MARK: - Sample Data for Development

extension BulletinPost {
    static let samplePosts: [BulletinPost] = [
        BulletinPost(
            title: "🌟 Employee of the Month - January 2025",
            content: "Congratulations to Sarah Chen from our DevOps team! Sarah has shown exceptional leadership in our cloud migration project, reducing deployment time by 40% and mentoring 3 junior developers. Her dedication to both technical excellence and team collaboration exemplifies our company values.\n\n🎉 Join us in celebrating Sarah's achievements!",
            type: .employeeRecognition,
            authorId: "hr_manager_001",
            authorName: "Mike Rodriguez",
            authorRole: "HR Manager",
            isSticky: true,
            isPriority: true,
            tags: ["employee-recognition", "devops", "leadership"],
            companyId: "company_001"
        ),
        
        BulletinPost(
            title: "🎄 Holiday Party - December 15th",
            content: "Join us for our annual holiday celebration!\n\n📅 Date: Friday, December 15th\n🕕 Time: 6:00 PM - 10:00 PM\n📍 Location: Grand Ballroom, Downtown Hotel\n\n🍽️ Dinner, drinks, and entertainment provided\n🎁 Gift exchange (optional, $25 limit)\n👔 Dress code: Business casual to semi-formal\n\nRSVP by December 8th through the company portal.",
            type: .socialEvent,
            authorId: "event_coordinator_001",
            authorName: "Lisa Thompson",
            authorRole: "Event Coordinator",
            expiresAt: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
            isSticky: true,
            tags: ["holiday", "social", "party"],
            companyId: "company_001"
        ),
        
        BulletinPost(
            title: "🚀 Q4 Company Milestones Achieved!",
            content: "Amazing news team! We've successfully achieved all our Q4 goals:\n\n✅ 25% revenue growth\n✅ 95% customer satisfaction score\n✅ Zero critical security incidents\n✅ 40+ new team members onboarded\n\nThank you to everyone who made this possible. Special recognition to our Sales, Engineering, and Customer Success teams for their outstanding efforts.\n\n🎯 Q1 2025 kickoff meeting scheduled for January 8th.",
            type: .milestone,
            authorId: "ceo_001",
            authorName: "David Kim",
            authorRole: "CEO",
            isPriority: true,
            tags: ["milestone", "achievement", "quarterly"],
            companyId: "company_001"
        ),
        
        BulletinPost(
            title: "📚 Mandatory Security Training - Due January 31st",
            content: "All employees must complete the updated cybersecurity training by January 31st, 2025.\n\n📖 Training covers:\n• Phishing prevention\n• Password best practices\n• Data handling procedures\n• Incident reporting\n\n⏱️ Estimated time: 45 minutes\n🔗 Access through Learning Management System\n📧 Reminder emails will be sent weekly\n\n❗ Failure to complete by deadline may result in system access restrictions.",
            type: .training,
            authorId: "security_manager_001",
            authorName: "Alex Chen",
            authorRole: "Security Manager",
            expiresAt: Calendar.current.date(byAdding: .day, value: 20, to: Date()),
            isPriority: true,
            tags: ["training", "security", "mandatory"],
            companyId: "company_001"
        ),
        
        BulletinPost(
            title: "🏃‍♀️ Wellness Wednesday: Lunchtime Yoga",
            content: "Join us for relaxing yoga sessions every Wednesday!\n\n🧘‍♀️ When: Wednesdays, 12:00 PM - 12:45 PM\n📍 Where: Conference Room B (mats provided)\n👩‍🏫 Instructor: Maria Santos (certified yoga instructor)\n\nBenefits:\n• Stress reduction\n• Improved flexibility\n• Better work-life balance\n• Team building\n\n🎯 No experience necessary - all levels welcome!\nWear comfortable clothing and bring a water bottle.",
            type: .wellness,
            authorId: "wellness_coordinator_001",
            authorName: "Jennifer Liu",
            authorRole: "Wellness Coordinator",
            tags: ["wellness", "yoga", "health"],
            companyId: "company_001"
        )
    ]
}
