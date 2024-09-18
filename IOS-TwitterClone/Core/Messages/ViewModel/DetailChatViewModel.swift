//
//  DetailChatViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 4/5/24.
//

import Firebase
import FirebaseFirestore
import SwiftUI
import PhotosUI

class DetailChatViewModel: ObservableObject {
    @Published var chatContent : String = ""
    @Published var messages : [Message] = [Message]()
    @Published var userCurrent : User? = UserService.shared.currentUser
    @Published var countStateScroll : Int = 0
    
    // handle imagePicker
    @Published var selectedItem : PhotosPickerItem? {
        didSet {
            Task { await loadImage() }
        }
    }
    @Published var imageMessage : Image?
    @Published var uiImage : UIImage?
    
    
    func sendMessage(toId : String) async throws {
        
        let imageMessageState = self.imageMessage
        let chatContentState = self.chatContent
        
        DispatchQueue.main.async {
            self.countStateScroll += 1
            self.chatContent = ""
            self.imageMessage = nil
        }

        guard let userCurrentUid = UserService.shared.currentUser?.id else { return }
        
        if imageMessage != nil {
            guard let urlImage = try await uploadImageMessage() else { return }
            
            try await MessageService.sendMessage(fromId: userCurrentUid, toId: toId, imageUrl: urlImage)
            
        } else {
            try await MessageService.sendMessage(fromId: userCurrentUid, toId: toId, content: chatContentState)
        }
        
        try await RecentMessageService.createRecentMessage(fromId: userCurrentUid, toId: toId, content: chatContentState)
    }
    
    func fetchAllMessagesFromUid(toId: String) async throws {
        guard let userCurrentUid = UserService.shared.currentUser?.id else { return }
        
        Firestore.firestore()
            .collection("messages")
            .document(userCurrentUid)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            let messageData = try change.document.data(as: Message.self)
                            self.messages.append(messageData)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    self.countStateScroll += 1
                })
            }
    }
    
    @MainActor
    func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.imageMessage = Image(uiImage: uiImage)
    }
    
    func uploadImageMessage() async throws -> String? {
        guard let image = self.uiImage else { return nil }
        
        guard let imageUrl = try await ImageUploader.uploadMedia(media: image, type: .imageMessage) else { return nil }
        
        
        return imageUrl
    }
}
