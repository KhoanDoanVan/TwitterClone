//
//  Comment.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 29/4/24.
//

import Foundation

struct Comment: Encodable, Decodable, Identifiable {
    let id : String
    let ownerUid : String
    var commentsUid : [String]?
    let create : Date
    let content : String
    var imageUrl : String?
    var postId : String?
}
