//
//  NotificationService.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 2/6/24.
//

import Firebase
import FirebaseFirestore


class NotificationService {
    
    static var shared = NotificationService()
    
    static func fetchNotificationById(userId: String) async throws -> [Notification] {
        let snapshot = try await Firestore.firestore().collection("notifications").whereField("toId", in: [userId]).getDocuments()
        return try snapshot.documents.compactMap({
            try $0.data(as: Notification.self)
        })
    }
    
    static func sendNotification(notification: Notification) async throws {
        let notificationData = try Firestore.Encoder().encode(notification)
        
        try await Firestore.firestore()
            .collection("notifications")
            .addDocument(data: notificationData)
    }
}
