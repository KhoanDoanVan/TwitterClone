//
//  Notification.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 2/6/24.
//

import Foundation

struct Notification: Encodable, Decodable, Identifiable {
    let id: String
    let toId: String
    let fromId: String
    let type: NotificationType
    var content: String?
    var tweetId: String?
    var commentId: String?
}
