import SwiftUI
import FirebaseAuth

struct SplashView: View {
    
    @State private var goToLogin = false
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0.0
    @State private var goToHome = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    colors: [.blue, .purple, .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 50)
                {
                    Image("LOGO")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 580)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .shadow(color: .purple, radius: 20)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .opacity(opacity)
                }
                
            }
            .onAppear
            {
                withAnimation(.easeIn(duration: 1.2))
                {
                    scale = 1.0
                    opacity = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                {
                    if Auth.auth().currentUser != nil
                    {
                        goToHome = true
                    }
                    else
                    {
                        goToLogin = true
                    }
                }
            }
            .navigationDestination(isPresented: $goToLogin)
            {
                SingupView()
            }
            .navigationDestination(isPresented: $goToHome)
            {
                HomeView()
            }
        }
    }
}
#Preview {
    SplashView()
}
