//
//  MessageViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 3/5/24.
//

import Firebase
import FirebaseFirestore

@MainActor
class MessageViewModel: ObservableObject {
    @Published var openNewMessages : Bool = false
    @Published var searchText : String = ""
    @Published var recentMessages : [RecentMessage] = [RecentMessage]()
    @Published var userCurrent : User? = UserService.shared.currentUser
    @Published var searchRecentMessages : [RecentMessage] = [RecentMessage]()
    
    init() {
        Task {
            try await fetchAllRecentMessage()
        }
    }
    
    
    func fetchAllRecentMessage() async throws {
        guard let userCurrentUid = UserService.shared.currentUser?.id else { return }
        
        Firestore.firestore()
            .collection("recentMessages")
            .document(userCurrentUid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    Task {
                        let documentID = change.document.documentID
                        
                        if let index = self.recentMessages.firstIndex(where: { rm in
                            return rm.toId == documentID
                        }){
                            self.recentMessages.remove(at: index)
                        }
                        
                        do {
                            var recentMessage = try change.document.data(as: RecentMessage.self)
                            recentMessage.user = try await UserService.fetchUser(withUid: recentMessage.toId)
                            self.recentMessages.insert(recentMessage, at: 0)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                })
            }
    }
    
    func filterRecentMessageByKeySearch() {
        let keySearch = self.searchText.lowercased()
        
        self.searchRecentMessages = recentMessages.filter({ recentMessage in
            recentMessage.user?.fullname.lowercased().contains(keySearch) ?? false || recentMessage.user?.username.lowercased().contains(keySearch) ?? false
        })
    }
}
