import SwiftUI
import FirebaseDatabase
import FirebaseAuth
import PhotosUI

struct AddContactView: View {
    
    @State private var users: [UserModel] = []
    @State private var userName = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                VStack
                {
                    HStack
                    {
                        Button
                        {
                            dismiss()
                            
                        } label: {
                            
                            ZStack
                            {
                                Circle()
                                    .fill(.white.opacity(0.15))
                                    .frame(width: 42, height: 42)
                                
                                Circle()
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                                    .frame(width: 42, height: 42)
                                
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        HStack
                        {
                            //  Text("Users")
                            //  .foregroundColor(.white)
                            //  .font(.title2.bold())
                            
                            Text(userName)
                                .foregroundColor(.white)
                                .font(.headline)
                            
                        }
                        
                        Spacer()
                        
                        Circle()
                            .fill(.clear)
                            .frame(width: 42, height: 42)
                    }
                    .padding()
                    ScrollView
                    {
                        VStack(spacing: 15)
                        {
                            ForEach(users) { user in
                                
                                NavigationLink
                                {
                                    ChatView(
                                        user: [
                                            "id": user.id,
                                            "name": user.name,
                                            "phone": user.phone,
                                            "image": user.image
                                        ]
                                    )
                                } label: {
                                    
                                    HStack(spacing: 15) {
                                        
                                        if let imageUrl = URL(string: user.image) {
                                            
                                            AsyncImage(url: imageUrl) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 55, height: 55)
                                            .clipShape(Circle())

                                        } else {
                                            
                                            Circle()
                                                .fill(.blue.opacity(0.3))
                                                .frame(width: 55, height: 55)
                                                .overlay {
                                                    Image(systemName: "person.fill")
                                                        .foregroundColor(.white)
                                                }
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            
                                            Text(user.name)
                                                .foregroundColor(.white)
                                                .font(.headline)
                                            
                                            Text(user.phone)
                                                .foregroundColor(.gray)
                                                .font(.subheadline)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(.white.opacity(0.08))
                                    .cornerRadius(20)
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear
        {
            fetchUsers()
            fetchUserName()
        }
    }
    func fetchUsers()
    {
        let ref = Database.database().reference()
        
        ref.child("Users").observeSingleEvent(of: .value) { snapshot in
            
            var tempUsers: [UserModel] = []
            
            for child in snapshot.children
            {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {
                    
                    let id = snap.key
                    
                    if id != Auth.auth().currentUser?.uid
                    {
                        
                        let name = value["name"] as? String ?? ""
                        let phone = value["phoneNumber"] as? String ?? ""
                        let image = value["image"] as? String ?? ""
                        
                        let user = UserModel(
                            id: id,
                            name: name,
                            phone: phone,
                            image: image
                        )
                        
                        tempUsers.append(user)
                    }
                }
            }
            
            self.users = tempUsers
        }
    }
    func fetchUserName()
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference()
            .child("Users")
            .child(uid)
            .observeSingleEvent(of: .value) { snapshot in
                
                if let data = snapshot.value as? [String: Any]
                {
                    userName = data["name"] as? String ?? ""
                }
            }
    }
    
}
#Preview {
    AddContactView()
}
