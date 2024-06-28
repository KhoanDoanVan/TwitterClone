//
//  CommentViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 29/4/24.
//

import Foundation

class CommentViewModel: ObservableObject {
    @Published var user : User?
    
    @MainActor
    func fetchUser(userUid : String) async throws {
        do {
            self.user = try await UserService.fetchUser(withUid: userUid)
        } catch {
            print(error.localizedDescription)
        }
    }
}
