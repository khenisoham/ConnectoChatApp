import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var message = ""
    @State private var isLoading = false
    @State private var goToHome = false
    
    var body: some View {
        
        NavigationStack
        {
            VStack(spacing: 30)
            {
                Spacer()
                
                Image("LOGO")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .shadow(color: .purple, radius: 10)
                
                Text("Welcome Back")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                VStack(spacing: 22)
                {
                    VStack(alignment: .leading, spacing: 8)
                    {
                        Text("Email")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack
                        {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white)
                            
                            TextField("Enter your email", text: $email)
                                .foregroundColor(.white)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.3))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 8)
                    {
                        Text("Password")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack
                        {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                            
                            SecureField("Enter your password", text: $password)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.3))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal)
                
                Button
                {
                    Task {
                        await loginfetch()
                    }
                } label: {
                    
                    Text("LOGIN")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 62)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.blue,
                                    Color.purple
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(22)
                        .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 6)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                HStack
                {
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                    
                    Text("or")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                }
                .padding(.horizontal, 60)
                .padding(.top, 10)
                
                HStack(spacing: 5)
                {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                    
                    NavigationLink(destination: SingupView())
                    {
                        Text("Signup")
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                    }
                }
                .font(.footnote)
                .padding()
                
                Spacer()
                
                NavigationLink(destination: HomeView(), isActive: $goToHome)
                {
                    EmptyView()
                }
                
            }
            .background(
                LinearGradient(
                    colors: [.blue, .purple, .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
    func loginfetch() async {
        
        if email.isEmpty || password.isEmpty
        {
            message = "Enter email & password"
            return
        }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            DispatchQueue.main.async
            {
                isLoading = false
            }
            if let error = error
            {
                DispatchQueue.main.async
                {
                    message = error.localizedDescription
                }
                print("Login error:\(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async
            {
                message = "Login success"
                goToHome = true
            }
        }
    }
}
#Preview {
    LoginView()
}
