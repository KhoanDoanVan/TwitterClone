//
//  ObjectPostRealtime.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 27/4/24.
//

import Foundation


struct ObjectPostRealtime: Encodable, Decodable {
    var likes : Int
    var comments : Int
    var reupload : Int
}
