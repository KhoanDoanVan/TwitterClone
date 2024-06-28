//
//  Tweet.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//

import Foundation

struct Tweet: Encodable, Decodable, Identifiable {
    let id : String
    let content : String
    let createDate : Date
    var imageUrl : String?
    var videoUrl : String?
    let ownerUid : String
    var user : User?
}
