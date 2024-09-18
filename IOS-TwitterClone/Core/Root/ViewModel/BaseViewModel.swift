//
//  BaseViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import Combine
import SwiftUI

class BaseViewModel : ObservableObject {
    @Published var currentUser : User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            try await setupSubscriber()
        }
    }
    
    @MainActor
    private func setupSubscriber() async throws {
        UserService.shared.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
            self?.currentUser = user
        }
        .store(in: &cancellables)
    }
}
