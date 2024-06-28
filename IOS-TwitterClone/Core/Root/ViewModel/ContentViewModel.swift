//
//  ContentViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 15/04/2024.
//

import Combine
import Firebase

@MainActor
class ContentViewModel : ObservableObject {
    @Published var userSession : FirebaseAuth.User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriber()
    }
    

    func setupSubscriber() {
        AuthService.shared.$userSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
    }
}
