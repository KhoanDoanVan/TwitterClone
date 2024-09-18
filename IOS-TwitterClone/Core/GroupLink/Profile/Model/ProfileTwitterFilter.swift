//
//  ProfileTwitterFilter.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 25/4/24.
//

import Foundation


enum ProfileTwitterFilter: Int, CaseIterable, Identifiable{
    case tweets
    case tweetsAndReplies
    case media
    case likes
    
    var title: String{
        switch self{
        case .tweets:
            return "Tweets"
        case .tweetsAndReplies:
            return "Replies"
        case .media:
            return "Media"
        case .likes:
            return "Likes"
        }
    }
    
    var id : Int{ return self.rawValue } // rawValue is 0, 1, 2, 3
}
