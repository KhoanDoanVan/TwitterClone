//
//  Like.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 28/4/24.
//

import Foundation

struct Like : Encodable {
    let id : String
    let userIds : [String]?
}
