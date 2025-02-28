import FirebaseAuth
import Combine
import CocoaLumberjackSwift

class AuthService: ObservableObject {
    @Published var user: User?
    static let shared = AuthService()
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            completion(.failure(NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email or password cannot be empty."])))
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                DDLogError("Firebase Auth Error: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let user = result?.user {
                DDLogInfo("User signed in successfully: \(user.email ?? "No Email")")
                completion(.success(user))
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            DDLogInfo("User signed out successfully.")
        } catch {
            DDLogError("Sign out error: \(error.localizedDescription)")
        }
    }
}
