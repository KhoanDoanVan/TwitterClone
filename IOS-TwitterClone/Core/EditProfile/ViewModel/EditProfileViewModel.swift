//
//  EditProfileViewModel.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI
import PhotosUI

enum TypeUpload {
    case imageProfile, backgroundProfile, imageTweet, videoTweet, imageMessage
}

class EditProfileViewModel: ObservableObject {
    
    // image Picker
    @Published var selectedUserImage : PhotosPickerItem? {
        didSet {
            Task {
                await loadImageUserProfile(type: .imageProfile)
            }
        }
    }
    @Published var profileUserImage : Image?
    private var uiUserImage : UIImage?
    @Published var selectedBackgroundImage : PhotosPickerItem? {
        didSet {
            Task {
                await loadImageUserProfile(type: .backgroundProfile)
            }
        }
    }
    @Published var profileBackgroundImage : Image?
    private var uiBackgroundImage : UIImage?
    
    // others
    @Published var bio : String?
    
    @MainActor
    func loadImageUserProfile(type : TypeUpload) async {
        guard let item = type == .backgroundProfile ? selectedBackgroundImage : selectedUserImage else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        
        switch (type) {
        case .backgroundProfile:
            self.uiBackgroundImage = uiImage
            self.profileBackgroundImage = Image(uiImage: uiImage)
        
        case .imageProfile:
            self.uiUserImage = uiImage
            self.profileUserImage = Image(uiImage: uiImage)
            
        case .imageTweet:
            ""
            
        case .videoTweet:
            ""
            
        case .imageMessage:
            ""
        }
    }
    
    func updateEdit() async throws {
        if uiUserImage != nil {
            try await updateImageUserProfile()
        }
        
        if uiBackgroundImage != nil {
            try await updateImageBackgroundProfile()
        }
    }

    
    func updateImageUserProfile() async throws {
        guard let image = self.uiUserImage else { return }
        guard let imageUrl = try await ImageUploader.uploadMedia(media: image, type: .imageProfile) else { return }
        try await UserService.shared.updateImageUser(withImageUrl: imageUrl)
    }
    
    func updateImageBackgroundProfile() async throws {
        guard let image = self.uiBackgroundImage else { return }
        guard let imageUrl = try await ImageUploader.uploadMedia(media: image, type: .backgroundProfile) else { return }
        try await UserService.shared.updateImageBackgroundUser(withImageUrl: imageUrl)
    }
}

