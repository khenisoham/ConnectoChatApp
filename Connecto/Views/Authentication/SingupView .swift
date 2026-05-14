import SwiftUI
import FirebaseDatabaseInternal
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct SingupView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var message = ""
    @State private var isLoading = false
    @State private var goToLogin = false
    @State private var goToHome = false
    
    var body: some View {
        
        NavigationStack
        {
            ScrollView(showsIndicators: false)
            {
                VStack(spacing: 30)
                {
                    Spacer()
                    
                    Image("LOGO")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240)
                        .shadow(color: .purple, radius: 10)
                    
                    VStack(spacing: 22)
                    {
                        VStack(alignment: .leading, spacing: 8)
                        {
                            Text("Name")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack
                            {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                
                                TextField("Enter your name", text: $name)
                                    .foregroundColor(.white)
                                    .autocorrectionDisabled()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.3))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white,lineWidth: 1)
                            )
                        }
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
                    
                    Button {
                        Task
                        {
                            await signupdata()
                        }
                    } label: {
                        
                        Text("CREATE ACCOUNT")
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
                    HStack {
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
                    
                    HStack(spacing: 18)
                    {
                        Button
                        {
                           loginwithgoogle()
                        }
                        label:
                        {
                            HStack(spacing: 12)
                            {
                                Image("google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                
                                Text("GOOGLE")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 70)
                            .background(
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.08),
                                                Color.white.opacity(0.03)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1.2)
                            )
                        }
                        
                        Button
                        {
                            
                        }
                        label:
                        {
                            HStack(spacing: 12)
                            {
                                Image(systemName: "applelogo")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                
                                Text("APPLE")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 70)
                            .background(
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.08),
                                                Color.white.opacity(0.03)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1.2)
                            )
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 5)
                    {
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                        
                        NavigationLink(destination: LoginView())
                        {
                            Text("Login")
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                        }
                    }
                    .font(.footnote)
                    .padding()
                    
                    Spacer()
                    NavigationLink(destination: LoginView(), isActive: $goToLogin)
                    {
                        EmptyView()
                    }
                    NavigationLink(destination: HomeView(), isActive: $goToHome)
                   {
                       EmptyView()
                   }
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
    func signupdata() async
    {
        
        if name.isEmpty || email.isEmpty || password.isEmpty
        {
            message = "All fields are required"
            return
        }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
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
                print("Signup error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async
            {
                if let user = authResult?.user
                {
                    let uid = user.uid
                    
                    let ref = Database.database().reference()
                    
                    ref.child("Users").child(uid).setValue([
                        "name": name,
                        "phoneNumber": "",
                        "bio": "",
                        "image": ""
                    ])
                }
                message = "Signup success"
                goToLogin = true
            }
        }
    }
    func loginwithgoogle()
    {
        guard let clientID = FirebaseApp.app()?.options.clientID else
        {
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let viewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            
            guard error == nil else
            {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { result, error in
                
                if let error = error
                {
                    print("Login failed: \(error.localizedDescription)")
                    message = error.localizedDescription
                    return
                }
                
                if let user = result?.user
                {
                    let uid = user.uid
                    
                    let ref = Database.database().reference()
                    
                    ref.child("Users").child(uid).setValue([
                        "name": user.displayName ?? "",
                        "phoneNumber": user.phoneNumber ?? "",
                        "bio": "",
                        "image": user.photoURL?.absoluteString ?? ""
                    ])
                    
                    print("user login successful ::: \(user.email ?? "No Email")")
                    
                    DispatchQueue.main.async
                    {
                        goToHome = true
                    }
                }
            }
        }
    }
}
#Preview {
    SingupView()
}
