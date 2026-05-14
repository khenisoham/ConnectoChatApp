import Foundation

struct MessageModel: Identifiable {
    
    var id: String
    var senderId: String
    var receiverId: String
    var message: String
    var time: Double
    var status: String
    var edited: Bool
    var replyMessage: String
    var replySender: String
    var reactions: [String: String]
}
