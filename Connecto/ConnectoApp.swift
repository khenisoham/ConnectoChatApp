import SwiftUI
import FirebaseCore

@main
struct ConnectoApp: App {
    init()
    {
        FirebaseApp.configure()
        print("firebase initilize successfully")
    }
    var body: some Scene {
        WindowGroup
        {
            SplashView()
        }
    }
}
