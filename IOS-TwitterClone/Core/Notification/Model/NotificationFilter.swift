//
//  NotificationFilter.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/5/24.
//

import Foundation

enum NotificationFilter: Int, CaseIterable, Identifiable {
    case all
    case mentions
    
    var title : String {
        switch(self) {
        case .all :
            return "All"
        case .mentions :
            return "Mentions"
        }
    }
    
    var id : Int {
        return self.rawValue
    }
}
