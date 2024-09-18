//
//  Message.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 3/5/24.
//

import Firebase
import FirebaseFirestore

struct Message : Encodable, Decodable, Hashable {
    let fromId : String
    let toId : String
    var content : String?
    var imageUrl : String?
    let timestamp : Timestamp
}
