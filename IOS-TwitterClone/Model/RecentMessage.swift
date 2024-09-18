//
//  RecentMessage.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 3/5/24.
//

import Firebase
import FirebaseFirestore

struct RecentMessage: Decodable, Encodable, Identifiable {
    let id : String
    var content : String
    let fromId : String
    let toId : String
    let timestamp : Timestamp
    var user : User?
}
