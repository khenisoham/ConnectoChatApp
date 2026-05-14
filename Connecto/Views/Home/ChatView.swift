import SwiftUI
import FirebaseDatabaseInternal
import FirebaseAuth

struct ChatView: View {
    
    var user: [String:Any]
    @State private var message = ""
    @Environment(\.dismiss) var dismiss
    @State private var messages: [MessageModel] = []
    @State private var editingMessageId = ""
    @State private var isEditing = false
    @State private var replyingToMessage = ""
    @State private var replyingToSender = ""
    @State private var isTyping = false
    
    var body: some View {
        ZStack
        {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0)
            {
                HStack(spacing: 15)
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
                                .stroke(.white.opacity(0.2),
                                        lineWidth: 1)
                                .frame(width: 42, height: 42)
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18,
                                              weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    VStack(alignment: .leading,
                           spacing: 3)
                    {
                        Text(user["name"] as? String ?? "")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        if isTyping
                        {
                            Text("Typing...")
                                .font(.caption.bold())
                                .foregroundColor(.green)
                        }
                        else
                        {
                            Text(user["isOnline"] as? Bool == true ? "Online" : "Offline")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    
                    Spacer()
                    
                   Button {
                        
                        
                        
                    } label: {
                        
                        ZStack
                        {
                            Circle()
                                .fill(.white.opacity(0.15))
                                .frame(width: 42, height: 42)
                            
                            Circle()
                                .stroke(.white.opacity(0.2),
                                        lineWidth: 1)
                                .frame(width: 42, height: 42)
                            
                            Image(systemName: "phone.fill")
                                .foregroundColor(.white)
                        }
                    }
                    Button
                    {
                        
                    } label: {
                        
                        ZStack
                        {
                            Circle()
                                .fill(.white.opacity(0.15))
                                .frame(width: 42, height: 42)
                            
                            Circle()
                                .stroke(.white.opacity(0.2),
                                        lineWidth: 1)
                                .frame(width: 42, height: 42)
                            
                            Image(systemName: "video.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                
                ScrollViewReader { proxy in
                    
                    ScrollView
                    {
                        VStack(spacing: 15)
                        {
                            ForEach(messages) { msg in
                                
                                HStack
                                {
                                    if msg.senderId == Auth.auth().currentUser?.uid {
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 5)
                                        {
                                            if !msg.replyMessage.isEmpty
                                            {
                                                VStack(alignment: .leading,
                                                       spacing: 3)
                                                {
                                                    Text(msg.replySender)
                                                        .font(.caption.bold())
                                                        .foregroundColor(.white)
                                                    
                                                    Text(msg.replyMessage)
                                                        .font(.caption)
                                                        .foregroundColor(.white.opacity(0.8))
                                                        .lineLimit(1)
                                                }
                                                .padding(8)
                                                .background(.white.opacity(0.15))
                                                .cornerRadius(10)
                                            }
                                            
                                            Text(msg.message)
                                                .padding()
                                                .background(.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(18)
                                            
                                            
                                            
                                                .contextMenu
                                            {
                                                Section
                                                {
                                                    Button("❤️")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "❤️")
                                                    }
                                                    
                                                    Button("😂")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "😂")
                                                    }
                                                    
                                                    Button("👍")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "👍")
                                                    }
                                                    
                                                    Button("😮")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "😮")
                                                    }
                                                    
                                                    Button("😢")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "😢")
                                                    }
                                                    
                                                    Button("🙏")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "🙏")
                                                    }
                                                }
                                                
                                                Button
                                                {
                                                    replyMessage(msg: msg)
                                                } label: {
                                                    Label("Reply", systemImage: "arrowshape.turn.up.left")
                                                }
                                                
                                                Button
                                                {
                                                    message = msg.message
                                                    editMessage(messageId: msg.id)
                                                    
                                                } label: {
                                                    Label("Edit Message", systemImage: "pencil")
                                                }
                                                
                                                Button(role: .destructive)
                                                {
                                                    deleteForMe(messageId: msg.id)
                                                } label: {
                                                    Label("Delete For Me", systemImage: "trash")
                                                }
                                                
                                                Button(role: .destructive)
                                                {
                                                    deleteForEveryone(messageId: msg.id)
                                                } label: {
                                                    Label("Delete For Everyone", systemImage: "trash.fill")
                                                }
                                            }
                                            
                                            HStack(spacing: 4) {
                                                
                                                Text(formatTime(msg.time))
                                                    .font(.caption2)
                                                    .foregroundColor(.gray)
                                                
                                                Image(systemName: tickIcon(msg.status))
                                                    .font(.caption2)
                                                    .foregroundColor(
                                                        msg.status == "read" ?
                                                            .blue :
                                                                .gray
                                                    )
                                            }
                                            if !msg.reactions.isEmpty
                                            {
                                                HStack(spacing: 4)
                                                {
                                                    ForEach(Array(msg.reactions.values),
                                                            id: \.self)
                                                    { emoji in
                                                        
                                                        Text(emoji)
                                                            .font(.caption)
                                                    }
                                                }
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(.white.opacity(0.1))
                                                .cornerRadius(10)
                                            }
                                        }
                                    }
                                    else {
                                        
                                        VStack(alignment: .leading, spacing: 5)
                                        {
                                            if !msg.replyMessage.isEmpty
                                            {
                                                VStack(alignment: .leading,
                                                       spacing: 3)
                                                {
                                                    Text(msg.replySender)
                                                        .font(.caption.bold())
                                                        .foregroundColor(.blue)
                                                    
                                                    Text(msg.replyMessage)
                                                        .font(.caption)
                                                        .foregroundColor(.white.opacity(0.8))
                                                        .lineLimit(1)
                                                }
                                                .padding(8)
                                                .background(.white.opacity(0.15))
                                                .cornerRadius(10)
                                            }
                                            
                                            Text(msg.message)
                                                .padding()
                                                .background(.gray.opacity(0.3))
                                                .foregroundColor(.white)
                                                .cornerRadius(18)
                                            
                                                .contextMenu
                                            {
                                                Section
                                                {
                                                    Button("❤️")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "❤️")
                                                    }
                                                    
                                                    Button("😂")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "😂")
                                                    }
                                                    
                                                    Button("👍")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "👍")
                                                    }
                                                    
                                                    Button("😮")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "😮")
                                                    }
                                                    
                                                    Button("😢")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "😢")
                                                    }
                                                    
                                                    Button("🙏")
                                                    {
                                                        addReaction(messageId: msg.id,
                                                                    emoji: "🙏")
                                                    }
                                                }
                                                Button {
                                                    replyMessage(msg: msg)
                                                } label: {
                                                    Label("Reply", systemImage: "arrowshape.turn.up.left")
                                                }
                                                
                                                Button {
                                                    
                                                } label: {
                                                    Label("Forward", systemImage: "arrowshape.turn.up.right")
                                                }
                                            }
                                            
                                            HStack(spacing: 4)
                                            {
                                                if msg.edited
                                                {
                                                    Text("edited")
                                                        .font(.caption2)
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Text(formatTime(msg.time))
                                                    .font(.caption2)
                                                    .foregroundColor(.gray)
                                                
                                            }
                                            if !msg.reactions.isEmpty
                                            {
                                                HStack(spacing: 4)
                                                {
                                                    ForEach(Array(msg.reactions.values),
                                                            id: \.self)
                                                    { emoji in
                                                        
                                                        Text(emoji)
                                                            .font(.caption)
                                                    }
                                                }
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(.white.opacity(0.1))
                                                .cornerRadius(10)
                                            }
                                        }
                                        
                                        Spacer()
                                    }
                                }
                                .id(msg.id)
                            }
                        }
                        .padding()
                    }
                    .onAppear {
                        
                        if let lastMsg = messages.last {
                            
                            DispatchQueue.main.async {
                                
                                proxy.scrollTo(lastMsg.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        
                        if let lastMsg = messages.last {
                            
                            withAnimation {
                                
                                proxy.scrollTo(lastMsg.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                VStack(spacing: 0)
                {
                    if !replyingToMessage.isEmpty
                    {
                        HStack
                        {
                            VStack(alignment: .leading,
                                   spacing: 4)
                            {
                                Text(replyingToSender)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                
                                Text(replyingToMessage)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Button
                            {
                                replyingToMessage = ""
                                replyingToSender = ""
                                
                            } label: {
                                
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(.white.opacity(0.1))
                    }
                    
                    HStack(spacing: 15)
                    {
                        TextField("Type a message...",
                                  text: $message)
                        .padding()
                        .background(.white.opacity(0.12))
                        .cornerRadius(18)
                        .foregroundColor(.white)
                        
                        .onChange(of: message) { value in
                            
                            setTypingStatus(!value.isEmpty)
                        }
                        
                        
                        Button
                        {
                            sendMessage()
                            
                        } label: {
                            
                            Image(systemName: "paperplane.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 55,
                                       height: 55)
                                .background(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: .purple.opacity(0.5),
                                        radius: 8)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear
        {
            fetchMessages()
            resetUnreadCount()
            observeTyping()
        }
    }
    func observeTyping()
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
            .child("typing")
            .child(otherId)
            .observe(.value) { snapshot in
                
                if snapshot.exists()
                {
                    isTyping = true
                }
                else
                {
                    isTyping = false
                }
            }
    }
    func setTypingStatus(_ isTyping: Bool)
    {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let otherId = user["id"] as? String
        else { return }
        
        let chatId = [currentUid, otherId]
            .sorted()
            .joined(separator: "_")
        
        let ref = Database.database().reference()
            .child("Chats")
            .child(chatId)
            .child("typing")
            .child(currentUid)
        
        if isTyping
        {
            ref.setValue(true)
        }
        else
        {
            ref.removeValue()
        }
    }
    func sendMessage()
    {
        guard let senderId = Auth.auth().currentUser?.uid else { return }
        
        if message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return
        }
        
        if isEditing
        {
            Database.database().reference()
                .child("Messages")
                .child(editingMessageId)
                .child("message")
                .setValue(message)
            
            isEditing = false
            editingMessageId = ""
            message = ""
            setTypingStatus(false)
            
            return
        }
        
        let receiverId = user["id"] as? String ?? ""
        
        let messageRef = Database.database().reference()
            .child("Messages")
            .childByAutoId()
        
        let messageId = messageRef.key ?? ""
        
        let data: [String: Any] = [
            "senderId": senderId,
            "receiverId": receiverId,
            "message": message,
            "time": ServerValue.timestamp(),
            "status": "sent",
            "deletedFor": [:],
            "replyMessage": replyingToMessage,
            "replySender": replyingToSender
        ]
        
        messageRef.setValue(data) { error, _ in
            
            if error == nil {
                message = ""
            }
        }
        
        let chatId = [senderId, receiverId]
            .sorted()
            .joined(separator: "_")
        
        let chatData: [String: Any] = [
            "lastMessage": message,
            "users": [
                senderId: true,
                receiverId: true
            ],
            
            "unreadCount": [
                receiverId: ServerValue.increment(1)
            ]
        ]
        
        Database.database().reference()
            .child("Chats")
            .child(chatId)
            .setValue(chatData)
        
        message = ""
        replyingToMessage = ""
        replyingToSender = ""
        
        setTypingStatus(false)
    }
    func fetchMessages()
    {
        guard let myId = Auth.auth().currentUser?.uid else { return }
        
        let otherId = user["id"] as? String ?? ""
        
        
        Database.database().reference()
            .child("Messages")
            .observe(.value) { snapshot in
                
                var temp: [MessageModel] = []
                
                for child in snapshot.children
                {
                    if let snap = child as? DataSnapshot,
                       let value = snap.value as? [String: Any]
                    {
                        let senderId = value["senderId"] as? String ?? ""
                        let receiverId = value["receiverId"] as? String ?? ""
                        let message = value["message"] as? String ?? ""
                        let time = value["time"] as? Double ?? 0
                        let edited = value["edited"] as? Bool ?? false
                        let replyMessage = value["replyMessage"] as? String ?? ""
                        let replySender = value["replySender"] as? String ?? ""
                        let reactions = value["reactions"] as? [String: String] ?? [:]
                        
                        let status = value["status"] as? String ?? "sent"
                        
                        let deletedFor = value["deletedFor"] as? [String: Bool] ?? [:]
                        
                        if deletedFor[myId] == true
                        {
                            continue
                        }
                        
                        if (senderId == myId && receiverId == otherId) ||
                            (senderId == otherId && receiverId == myId)
                        {
                            
                            if receiverId == myId && status == "sent"
                            {
                                snap.ref.child("status")
                                    .setValue("delivered")
                            }
                            
                            if receiverId == myId
                            {
                                snap.ref.child("status")
                                    .setValue("read")
                            }
                            
                            let msg = MessageModel(
                                id: snap.key,
                                senderId: senderId,
                                receiverId: receiverId,
                                message: message,
                                time: time,
                                status: status,
                                edited: edited,
                                replyMessage: replyMessage,
                                replySender: replySender,
                                reactions: reactions
                            )
                            
                            temp.append(msg)
                        }
                    }
                }
                temp.sort
                {
                    $0.time < $1.time
                }
                self.messages = temp
            }
    }
    func formatTime(_ timestamp: Double) -> String
    {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        return formatter.string(from: date)
    }
    func tickIcon(_ status: String) -> String
    {
        switch status
        {
        case "sent":
            return "checkmark"
            
        case "delivered":
            return "checkmark.circle"
            
        case "read":
            return "checkmark.circle.fill"
            
        default:
            return "checkmark"
        }
    }
    func deleteForEveryone(messageId: String)
    {
        Database.database().reference()
            .child("Messages")
            .child(messageId)
            .removeValue()
    }
    func deleteForMe(messageId: String)
    {
        guard let myId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference()
            .child("Messages")
            .child(messageId)
            .child("deletedFor")
            .child(myId)
            .setValue(true)
    }
    func editMessage(messageId: String)
    {
        editingMessageId = messageId
        isEditing = true
    }
    func replyMessage(msg: MessageModel)
    {
        replyingToMessage = msg.message
        replyingToSender = msg.senderId ==
        Auth.auth().currentUser?.uid ?
        "You" :
        (user["name"] as? String ?? "")
    }
    func addReaction(messageId: String,
                     emoji: String)
    {
        guard let myId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference()
            .child("Messages")
            .child(messageId)
            .child("reactions")
            .child(myId)
            .setValue(emoji)
    }
    func resetUnreadCount()
    {
        guard let myId = Auth.auth().currentUser?.uid else { return }
        
        let otherId = user["id"] as? String ?? ""
        
        let chatId = [myId, otherId]
            .sorted()
            .joined(separator: "_")
        
        Database.database().reference()
            .child("Chats")
            .child(chatId)
            .child("unreadCount")
            .child(myId)
            .setValue(0)
    }
}
#Preview {
    ChatView(user: [
        "id": "123",
        "name": "Soham"
    ])
}
