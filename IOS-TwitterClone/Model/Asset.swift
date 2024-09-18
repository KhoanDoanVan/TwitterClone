//
//  Asset.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 19/04/2024.
//

import Photos
import SwiftUI

struct Asset : Identifiable {
    var id : String = UUID().uuidString
    var asset : PHAsset
    var image : UIImage
}
