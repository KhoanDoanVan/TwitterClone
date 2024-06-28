//
//  RecentMessageService.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 4/5/24.
//

import Firebase
import FirebaseFirestore

class RecentMessageService {
    
    static var shared = RecentMessageService()
    
    
    static func createRecentMessage(fromId: String, toId: String, content: String) async throws {
        let recentMessage = RecentMessage(id: UUID().uuidString, content: content, fromId: fromId, toId: toId, timestamp: Timestamp())
        let recentMessageRecive = RecentMessage(id: UUID().uuidString, content: content, fromId: toId, toId: fromId, timestamp: Timestamp())
        let recentMessageData = try Firestore.Encoder().encode(recentMessage)
        let recentMessageReciveData = try Firestore.Encoder().encode(recentMessageRecive)
        
        try await Firestore.firestore()
            .collection("recentMessages")
            .document(fromId)
            .collection("messages")
            .document(toId)
            .setData(recentMessageData)
        
        try await Firestore.firestore()
            .collection("recentMessages")
            .document(toId)
            .collection("messages")
            .document(fromId)
            .setData(recentMessageReciveData)
    }
}
