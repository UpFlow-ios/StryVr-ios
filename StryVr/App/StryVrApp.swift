import SwiftUI
import Firebase

@main
struct StryVrApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authViewModel = AuthViewModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}

// MARK: - AuthViewModel
class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    
    @Published var userSession: FirebaseAuth.User?
    
    private init() {
        self.userSession = Auth.auth().currentUser
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let user = result?.user, error == nil else {
                print("Sign-in error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self?.userSession = user
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userSession = nil
            }
        } catch {
            print("Sign-out error: \(error.localizedDescription)")
        }
    }
}

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        do {
            FirebaseApp.configure()
            print("✅ Firebase initialized successfully")
        } catch let error {
            print("❌ Error configuring Firebase: \(error.localizedDescription)")
        }
        return true
    }
}
