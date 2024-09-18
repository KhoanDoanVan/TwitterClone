//
//  SearchViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var search : String = "" {
        didSet {
            fetchUsersBySearching()
        }
    }
    @Published var users = [User]()
    
    init() {
        Task {
            try await fetchUsers()
        }
    }
    
    func fetchUsersBySearching() {
        Task {
            do {
                let fetchedUsers = try await UserService.shared.fetchUsers()
                await updateUsers(fetchedUsers)
            } catch {
                print("Error fetching users: \(error)")
            }
        }
    }
    
    @MainActor
    private func updateUsers(_ fetchedUsers: [User]) async {
        let search = self.search.lowercased()
        let filterUsers = fetchedUsers.filter {
            $0.username.lowercased().contains(search)
        }
        self.users = filterUsers
    }
    
    @MainActor
    func fetchUsers() async throws {
        self.users = try await UserService.shared.fetchUsers()
    }
}
