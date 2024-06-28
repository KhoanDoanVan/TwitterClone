//
//  NotificationViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/5/24.
//

import Foundation

class NotificationViewModel: ObservableObject {
    @Published var selectFilter : NotificationFilter = NotificationFilter.all
    @Published var showSheet : Bool = false
    @Published var user : User?
    @Published var notifications = [Notification]()
    
    init() {
        Task {
            self.user = UserService.shared.currentUser
        }
    }
    
    @MainActor
    func fetchNotifications() async throws {
        self.notifications = try await NotificationService.fetchNotificationById(userId: user?.id ?? "")
    }
}
