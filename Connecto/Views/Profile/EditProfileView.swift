import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var bio = ""
    
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(
                colors: [.black, .purple.opacity(0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                HStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        
                        Image(systemName: "arrow.left")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Edit Profile")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 25)
                }
                .padding(.horizontal)
                .padding(.top)
                
                ZStack(alignment: .bottomTrailing) {
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 130, height: 130)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    
                    Button {
                        
                    } label: {
                        
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                .padding(.top)
                
                VStack(spacing: 18) {
                    
                    customTextField(
                        title: "Full Name",
                        text: $name,
                        icon: "person.fill"
                    )
                    
                    customTextField(
                        title: "Phone Number",
                        text: $phoneNumber,
                        icon: "phone.fill"
                    )
                    
                    VStack(alignment: .leading,
                           spacing: 10)
                    {
                        Label("Bio", systemImage: "quote.bubble.fill")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        TextEditor(text: $bio)
                            .frame(height: 120)
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(18)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                    }
                }
                .padding(.horizontal)
                
                Button {
                    
                    updateProfile()
                    
                } label: {
                    
                    HStack {
                        
                        if isLoading
                        {
                            ProgressView()
                                .tint(.white)
                        }
                        else
                        {
                            Image(systemName: "checkmark.circle.fill")
                            
                            Text("Save Changes")
                                .fontWeight(.semibold)
                        }
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
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchUserData()
        }
        .alert(alertMessage,
               isPresented: $showAlert)
        {
            Button("OK", role: .cancel) {
                
            }
        }
    }
    func customTextField(title: String,
                         text: Binding<String>,
                         icon: String) -> some View
    {
        VStack(alignment: .leading,
               spacing: 10)
        {
            Label(title, systemImage: icon)
                .foregroundColor(.white)
                .font(.headline)
            
            TextField(title,
                      text: text)
            .padding()
            .background(Color.white.opacity(0.08))
            .cornerRadius(18)
            .foregroundColor(.white)
        }
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
                
                self.bio = value["bio"] as? String ?? ""
            }
        }
    }

    func updateProfile()
    {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if name.isEmpty || phoneNumber.isEmpty
        {
            alertMessage = "Please fill all details"
            showAlert = true
            return
        }
        
        isLoading = true
        
        let data: [String: Any] = [
            
            "name": name,
            "phoneNumber": phoneNumber,
            "bio": bio
        ]
        
        Database.database()
            .reference()
            .child("Users")
            .child(uid)
            .updateChildValues(data)
        {
            error,
            _ in
            
            isLoading = false
            
            if let error = error
            {
                alertMessage = error.localizedDescription
                showAlert = true
            }
            else
            {
                alertMessage = "Profile Updated Successfully"
                showAlert = true
                dismiss()
            }
        }
    }
}

#Preview {
    
    NavigationStack {
        
        EditProfileView()
    }
}
