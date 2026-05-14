import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct HomeView: View {
    
    @State private var goToAdd = false
    @State private var goToProfile = false
    @State private var users: [[String:Any]] = []
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var profileImage = ""
    
    var body: some View {
        NavigationStack
        {
            ZStack(alignment: .bottomTrailing)
            {
                Color.black
                    .ignoresSafeArea()
                
                ScrollView
                {
                    VStack
                    {
                        HStack
                        {
                            Button
                            {
                                goToProfile = true
                            } label: {
                                
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
                                        .frame(width: 45, height: 45)
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
                                            .frame(width: 45, height: 45)
                                            .overlay {
                                                
                                                Image(systemName: "person.fill")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(.white)
                                            }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Button
                            {
                                
                            } label: {
                                
                                ZStack
                                {
                                    Circle()
                                        .fill(.white.opacity(0.15))
                                        .frame(width: 45, height: 45)
                                    
                                    Circle()
                                        .stroke(.white.opacity(0.2),
                                                lineWidth: 1)
                                        .frame(width: 45, height: 45)
                                    
                                    Image(systemName: "ellipsis")
                                        .font(.title3.bold())
                                        .foregroundColor(.white)
                                        .rotationEffect(.degrees(90))
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        HStack(spacing: 12)
                        {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.7))
                            
                            TextField("Search chats...", text: $searchText)
                                .foregroundColor(.white)
                            
                            if !searchText.isEmpty
                            {
                                Button
                                {
                                    searchText = ""
                                    
                                } label: {
                                    
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                        .padding()
                        .background(.white.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(.white, lineWidth: 1)
                        )
                        .cornerRadius(18)
                        .padding(.horizontal)
                        .padding(.top, 15)
                        
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            HStack(spacing: 12)
                            {
                                
                                categoryButton(title: "All")
                                
                                categoryButton(title: "Unread")
                                
                                categoryButton(title: "Favorites")
                                
                                categoryButton(title: "Groups")
                                
                                Button
                                {
                                    
                                } label: {
                                    
                                    ZStack
                                    {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [.blue, .purple],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 45, height: 45)
                                        
                                        Image(systemName: "plus")
                                            .font(.title3.bold())
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 15)
                        LazyVStack(spacing: 15)
                        {
                            ForEach(filteredUsers.indices, id: \.self) { index in
                                
                                let user = filteredUsers[index]
                                
                                NavigationLink
                                {
                                    ChatView(user: user)
                                    
                                } label: {
                                    
                                    HStack(spacing: 15)
                                    {
                                        if let imageUrl = user["image"] as? String,
                                           let url = URL(string: imageUrl)
                                        {
                                            AsyncImage(url: url) { image in
                                                
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                
                                            } placeholder: {
                                                
                                                ProgressView()
                                            }
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            
                                        }
                                        else
                                        {
                                            ZStack
                                            {
                                                Circle()
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [.blue, .purple],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .frame(width: 60, height: 60)
                                                
                                                Image(systemName: "person.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        VStack(alignment: .leading,
                                               spacing: 6)
                                        {
                                            Text(user["name"] as? String ?? "")
                                                .font(.title3.bold())
                                                .foregroundColor(.white)
                                            
                                            if user["isTyping"] as? Bool == true
                                            {
                                                Text("Typing...")
                                                    .font(.subheadline.bold())
                                                    .foregroundColor(.green)
                                            }
                                            
                                            else if let count = user["unreadCount"] as? Int,
                                                    count > 0
                                            {
                                                Text("\(count)+ new messages")
                                                    .font(.subheadline.bold())
                                                    .foregroundColor(.green)
                                                    .lineLimit(1)
                                            }
                                            else
                                            {
                                                Text(user["lastMessage"] as? String ?? "")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                    .lineLimit(1)
                                            }
                                        }
                                        Spacer()
                                        VStack(spacing: 8)
                                        {
                                            if user["isPinned"] as? Bool == true
                                            {
                                                Image(systemName: "pin.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(.white.opacity(0.12))
                                    .cornerRadius(22)
                                    .padding(.horizontal)
                                }
                                .contextMenu {
                                    
                                    Button {
                                        
                                        UIImpactFeedbackGenerator(style: .medium)
                                            .impactOccurred()
                                        
                                        pinChat(user)
                                        
                                    } label: {
                                        
                                        Label(
                                            user["isPinned"] as? Bool == true ?
                                            "Unpin Chat" :
                                                "Pin Chat",
                                            
                                            systemImage:
                                                user["isPinned"] as? Bool == true ?
                                            "pin.slash.fill" :
                                                "pin.fill"
                                        )
                                    }
                                    
                                    Button {
                                        
                                        UIImpactFeedbackGenerator(style: .medium)
                                            .impactOccurred()
                                        
                                        favoriteChat(user)
                                        
                                    } label: {
                                        
                                        Label(
                                            user["isFavorite"] as? Bool == true ?
                                            "Remove Favorite" :
                                                "Favorite",
                                            
                                            systemImage:
                                                user["isFavorite"] as? Bool == true ?
                                            "star.slash.fill" :
                                                "star.fill"
                                        )
                                    }
                                    
                                    Button {
                                        UIImpactFeedbackGenerator(style: .medium)
                                            .impactOccurred()
                                        muteChat(user)
                                        
                                    } label: {
                                        
                                        Label(
                                            user["isMuted"] as? Bool == true ?
                                            "Unmute" :
                                                "Mute",
                                            
                                            systemImage:
                                                user["isMuted"] as? Bool == true ?
                                            "bell.fill" :
                                                "bell.slash.fill"
                                        )
                                    }
                                    
                                    Button {
                                        UIImpactFeedbackGenerator(style: .medium)
                                            .impactOccurred()
                                        archiveChat(user)
                                        
                                    } label: {
                                        
                                        Label(
                                            user["isArchived"] as? Bool == true ?
                                            "Unarchive" :
                                                "Archive",
                                            
                                            systemImage:
                                                user["isArchived"] as? Bool == true ?
                                            "tray.full.fill" :
                                                "archivebox.fill"
                                        )
                                    }
                                    
                                    Divider()
                                    
                                    Button(role: .destructive)
                                    {
                                        UIImpactFeedbackGenerator(style: .medium)
                                            .impactOccurred()
                                        deleteChat(user)
                                        
                                    } label: {
                                        
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 100)
                    }
                }
                Button
                {
                    goToAdd = true
                } label: {
                    
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 65, height: 65)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(color: .purple.opacity(0.5),
                                radius: 10)
                        .scaleEffect(goToAdd ? 0.9 : 1)
                        .animation(.spring(response: 0.3,
                                           dampingFraction: 0.5),
                                   value: goToAdd)
                }
                .padding()
            }
            .onAppear
            {
                fetchUsers()
                setOnlineStatus(true)
                fetchCurrentUser()
            }
            NavigationLink(destination: AddContactView(),
                           isActive: $goToAdd)
            {
                EmptyView()
            }
            NavigationLink(destination: ProfileView(),
                           isActive: $goToProfile)
            {
                EmptyView()
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear
        {
            setOnlineStatus(false)
        }
    }
    func fetchUsers()
    {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference()
            .child("Chats")
            .observe(.value) { snapshot in
                
                var tempUsers: [[String:Any]] = []
                
                for child in snapshot.children
                {
                    if let snap = child as? DataSnapshot,
                       let value = snap.value as? [String:Any],
                       let users = value["users"] as? [String:Bool]
                    {
                        if users[currentUid] == true
                        {
                            let ids = Array(users.keys)
                            
                            let otherId = ids.first(where: {
                                $0 != currentUid
                            }) ?? ""
                            
                            Database.database().reference()
                                .child("Users")
                                .child(otherId)
                                .observeSingleEvent(of: .value) { userSnap in
                                    
                                    if var userData = userSnap.value as? [String:Any]
                                    {
                                        userData["id"] = otherId
                                        
                                        userData["lastMessage"] = value["lastMessage"] as? String ?? ""
                                        
                                        userData["isOnline"] = userSnap.childSnapshot(forPath: "isOnline").value as? Bool ?? false
                                        
                                        let pinnedBy = value["pinnedBy"] as? [String:Bool] ?? [:]
                                        
                                        userData["isPinned"] = pinnedBy[currentUid] == true
                                        
                                        let unreadData = value["unreadCount"] as? [String:Int] ?? [:]
                                        
                                        userData["unreadCount"] = unreadData[currentUid] ?? 0
                                        let favoriteData = value["favoritesBy"] as? [String:Bool] ?? [:]
                                        
                                        userData["isFavorite"] = favoriteData[currentUid] == true
                                        let mutedData = value["mutedBy"] as? [String:Bool] ?? [:]
                                        
                                        userData["isMuted"] = mutedData[currentUid] == true
                                        
                                        let archiveData = value["archivedBy"] as? [String:Bool] ?? [:]
                                        
                                        userData["isArchived"] = archiveData[currentUid] == true
                                        
                                        let deletedData = value["deletedBy"] as? [String:Bool] ?? [:]
                                        
                                        let typingData = value["typing"] as? [String:Bool] ?? [:]
                                        
                                        userData["isTyping"] = typingData[otherId] == true
                                        
                                        if deletedData[currentUid] == true
                                        {
                                            return
                                        }
                                        
                                        tempUsers.append(userData)
                                        self.users = tempUsers
                                    }
                                }
                        }
                    }
                }
            }
    }
    func categoryButton(title: String) -> some View
    {
        Button
        {
            selectedCategory = title
            
        } label: {
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .background(
                    selectedCategory == title ?
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    :
                        LinearGradient(
                            colors: [.white.opacity(0.12),
                                     .white.opacity(0.12)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                )
                .clipShape(Capsule())
                .animation(.spring(), value: selectedCategory)
        }
    }
    var filteredUsers: [[String:Any]]
    {
        var result = users
        
        if selectedCategory == "Unread"
        {
            result = result.filter {
                ($0["unreadCount"] as? Int ?? 0) > 0
            }
        }
        
        else if selectedCategory == "Favorites"
        {
            result = result.filter {
                ($0["isFavorite"] as? Bool ?? false)
            }
        }
        
        result = result.filter {
            !($0["isArchived"] as? Bool ?? false)
        }
        
        if !searchText.isEmpty
        {
            result = result.filter {
                ($0["name"] as? String ?? "")
                    .lowercased()
                    .contains(searchText.lowercased())
            }
        }
        
        return result.sorted {
            ($0["isPinned"] as? Bool ?? false)
            &&
            !($1["isPinned"] as? Bool ?? false)
        }
    }
    func setOnlineStatus(_ isOnline: Bool)
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference()
            .child("Users")
            .child(uid)
            .child("isOnline")
            .setValue(isOnline)
    }
    func pinChat(_ user: [String:Any])
    {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let otherId = user["id"] as? String
        else { return }
        
        let chatId = [currentUid, otherId]
            .sorted()
            .joined(separator: "_")
        
        let isPinned = user["isPinned"] as? Bool ?? false
        
        if isPinned
        {
            Database.database().reference()
                .child("Chats")
                .child(chatId)
                .child("pinnedBy")
                .child(currentUid)
                .removeValue()
        }
        else
        {
            Database.database().reference()
                .child("Chats")
                .child(chatId)
                .child("pinnedBy")
                .child(currentUid)
                .setValue(true)
        }
    }
    func favoriteChat(_ user: [String:Any])
    {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let otherId = user["id"] as? String
        else { return }
        
        let chatId = [currentUid, otherId]
            .sorted()
            .joined(separator: "_")
        
        let isFavorite = user["isFavorite"] as? Bool ?? false
        
        let ref = Database.database().reference()
            .child("Chats")
            .child(chatId)
            .child("favoritesBy")
            .child(currentUid)
        
        if isFavorite
        {
            ref.removeValue()
        }
        else
        {
            ref.setValue(true)
        }
    }
    
    func muteChat(_ user: [String:Any])
    {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let otherId = user["id"] as? String
        else { return }
        
        let chatId = [currentUid, otherId]
            .sorted()
            .joined(separator: "_")
        
        let isMuted = user["isMuted"] as? Bool ?? false
        
        let ref = Database.database().reference()
            .child("Chats")
            .child(chatId)
            .child("mutedBy")
            .child(currentUid)
        
        if isMuted
        {
            ref.removeValue()
        }
        else
        {
            ref.setValue(true)
        }
    }
    
    func archiveChat(_ user: [String:Any])
    {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let otherId = user["id"] as? String
        else { return }
        
        let chatId = [currentUid, otherId]
            .sorted()
            .joined(separator: "_")
        
        let isArchived = user["isArchived"] as? Bool ?? false
        
        let ref = Database.database().reference()
            .child("Chats")
            .child(chatId)
            .child("archivedBy")
            .child(currentUid)
        
        if isArchived
        {
            ref.removeValue()
        }
        else
        {
            ref.setValue(true)
        }
    }
    
    func deleteChat(_ user: [String:Any])
    {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let otherId = user["id"] as? String
        else { return }
        
        let chatId = [currentUid, otherId]
            .sorted()
            .joined(separator: "_")
        
        Database.database().reference()
            .child("Chats")
            .child(chatId)
            .child("deletedBy")
            .child(currentUid)
            .setValue(true)
    }
    func fetchCurrentUser()
    {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference()
            .child("Users")
            .child(uid)
            .observeSingleEvent(of: .value) { snapshot in
                
                if let value = snapshot.value as? [String:Any]
                {
                    self.profileImage = value["image"] as? String ?? ""
                }
            }
    }
}

#Preview {
    HomeView()
}
