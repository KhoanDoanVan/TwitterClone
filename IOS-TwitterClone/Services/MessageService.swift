//
//  MessageService.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 4/5/24.
//

import Firebase
import FirebaseFirestore

class MessageService {
    
    static var shared = MessageService()
    
    static func sendMessage(fromId : String, toId: String, content: String? = nil, imageUrl: String? = nil) async throws {
        
        var message : Message?
        
        if content != nil {
            message = Message(fromId: fromId, toId: toId, content: content, timestamp: Timestamp())
        } else {
            message = Message(fromId: fromId, toId: toId, imageUrl: imageUrl, timestamp: Timestamp())
        }
        
        let messageData = try Firestore.Encoder().encode(message)
        
        try await Firestore.firestore()
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
            .setData(messageData)
        
        try await Firestore.firestore()
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
            .setData(messageData)
    }
}
