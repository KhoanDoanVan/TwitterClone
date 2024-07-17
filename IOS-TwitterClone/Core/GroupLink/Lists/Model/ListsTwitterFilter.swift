//
//  ListsTwitterFilter.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/7/24.
//

import Foundation

enum ListsTwitterFilter: Int, CaseIterable, Identifiable {
    case subscribedTo
    case memberOf
    
    var title: String {
        switch self {
        case .subscribedTo:
            return "Subscribed To"
        case .memberOf:
            return "Member of"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
}
