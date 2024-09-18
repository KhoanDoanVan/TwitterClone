//
//  User.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 15/04/2024.
//

import Foundation

struct User : Decodable, Encodable, Identifiable {
    let id : String
    let email : String
    let username : String
    let fullname : String
    var profileImageUrl : String?
    var bio : String?
    var backgroundImageUrl : String?
    var following : [String]?
    var followers : [String]?
}
