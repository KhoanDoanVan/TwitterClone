//
//  NewMessageViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 4/5/24.
//

import Foundation

class NewMessageViewModel: ObservableObject {
    @Published var searchText : String = ""
    @Published var users : [User] = [User]()
    @Published var searchUsers : [User] = [User]()
    
    func filterUserByKeySearch() {
        let keySearch = self.searchText.lowercased()
        self.searchUsers = users.filter({ user in
            user.fullname.lowercased().contains(keySearch) || user.username.lowercased().contains(keySearch)
        })
    }
}
