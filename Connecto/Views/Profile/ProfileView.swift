import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct ProfileView: View {
    
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var bio = ""
    @State private var profileImage = ""
    @State private var isOnline = false
    @State private var joinedDate = ""
    @State private var goToEditProfile = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack
        {
            
            LinearGradient(
                colors: [.black, .purple.opacity(0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 25) {
                    
                    HStack {
                        
                        Button {
                            dismiss()
                        } label: {
                            
                            Image(systemName: "arrow.left")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("Profile")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                       
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 15)
                    {
                        ZStack(alignment: .bottomTrailing)
                        {
                            if let url = URL(string: profileImage),
                               !profileImage.isEmpty
                            {
                                AsyncImage(url: url) { image in
                                    
                                    image
                                        .resizable()
                                        .scaledToFill()
                                    
                                } placeholder: {
                                    
                                    ProgressView()
                                }
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                            }
                            else
                            {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 130, height: 130)
                                    .overlay {
                                        
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(.white)
                                    }
                            }
                            
                            Circle()
                                .fill(isOnline ? .green : .gray)
                                .frame(width: 22, height: 22)
                                .overlay {
                                    
                                    Circle()
                                        .stroke(.black, lineWidth: 3)
                                }
                        }
                        
                        VStack(spacing: 8)
                        {
                            HStack(spacing: 6)
                            {
                                Text(name)
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                            }
                            
                            Text(phoneNumber)
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(isOnline ? "Online" : "Offline")
                                .font(.subheadline.bold())
                                .foregroundColor(isOnline ? .green : .gray)
                        }
                    }
                    .padding(.top)
                    
                    if !bio.isEmpty {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Label("Bio", systemImage: "quote.bubble.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(bio)
                                .foregroundColor(.white.opacity(0.85))
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(22)
                        .padding(.horizontal)
                    }
                    VStack(spacing: 15)
                    {
                        profileRow(
                            icon: "calendar",
                            title: "Joined",
                            value: joinedDate
                        )
                        
                        profileRow(
                            icon: "message.fill",
                            title: "Chats",
                            value: "24 Conversations"
                        )
                        
                        profileRow(
                            icon: "photo.fill",
                            title: "Media Shared",
                            value: "12 Photos"
                        )
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 15)
                    {
                        Button {
                            goToEditProfile = true
                        } label: {
                            
                            HStack {
                                
                                Image(systemName: "square.and.pencil")
                                
                                Text("Edit Profile")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(18)
                        }
                        
                        Button {
                            
                            try? Auth.auth().signOut()
                            
                        } label: {
                            
                            HStack {
                                
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                
                                Text("Logout")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(18)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer(minLength: 30)
                }
                .padding(.top)
            }
            NavigationLink(destination: EditProfileView(),
                           isActive: $goToEditProfile)
            {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear
        {
            fetchUserData()
        }
    }
    
    func profileRow(icon: String,
                    title: String,
                    value: String) -> some View
    {
        HStack(spacing: 15) {
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading,
                   spacing: 5)
            {
                Text(title)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                Text(value)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .cornerRadius(20)
    }
    
    func fetchUserData()
    {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let reference = Database.database()
            .reference()
            .child("Users")
            .child(uid)
        
        reference.observeSingleEvent(of: .value) { snapshot in
            
            if let value = snapshot.value as? [String: Any]
            {
                self.name = value["name"] as? String ?? ""
                
                self.phoneNumber = value["phoneNumber"] as? String ?? ""
                
                self.bio = value["bio"] as? String ?? "Hey there! I am using Chat App."
                
                self.profileImage = value["image"] as? String ?? ""
                
                self.isOnline = value["isOnline"] as? Bool ?? false
                
                let timestamp = value["joinedDate"] as? Double ?? 0
                
                if timestamp != 0
                {
                    let date = Date(timeIntervalSince1970: timestamp)
                    
                    let formatter = DateFormatter()
                    
                    formatter.dateStyle = .medium
                    
                    self.joinedDate = formatter.string(from: date)
                }
                else
                {
                    self.joinedDate = "May 2026"
                }
            }
        }
    }
}
#Preview {
    NavigationStack
    {
        ProfileView()
    }
}
