import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // ✅ TEST: Retrieve Hugging Face API Key
        if let apiKey = SecureStorageService.shared.getAPIKey(service: "HuggingFace") {
            print("✅ Hugging Face API Key Retrieved: \(apiKey)")
        } else {
            print("🔴 Failed to Retrieve API Key")
        }
        
        return true
    }
}

