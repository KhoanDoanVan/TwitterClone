//
//  NotiCellViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 2/6/24.
//

import Foundation

class NotiCellViewModel: ObservableObject {
    @Published var fromIdUser: User?
    
    @MainActor
    func fetchUser(userId: String) async throws {
        self.fromIdUser = try await UserService.fetchUser(withUid: userId)
    }
}
