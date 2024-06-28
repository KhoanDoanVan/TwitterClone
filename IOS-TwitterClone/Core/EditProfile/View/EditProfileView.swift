//
//  EditProfileView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    let user : User
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EditProfileViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $viewModel.selectedBackgroundImage,label: {
                    if let image = viewModel.profileBackgroundImage {
                        image
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                    } else {
                        if let imageUrl = user.backgroundImageUrl {
                            RemoteImage(url: "\(imageUrl)")
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        } else {
                            ZStack{
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .foregroundStyle(Color(.systemGray3))
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 50))
                                    .foregroundStyle(Color(.systemGray))
                            }
                        }
                    }
                })
                
                HStack{
                    PhotosPicker(selection: $viewModel.selectedUserImage) {
                        if let image = viewModel.profileUserImage {
                            image
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        } else {
                            if let imageUrl = user.profileImageUrl {
                                RemoteImage(url: "\(imageUrl)")
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(50)
                            } else {
                                ZStack{
                                    Circle()
                                        .frame(width: 80)
                                        .foregroundStyle(.white)
                                    Circle()
                                        .frame(width: 70)
                                        .foregroundStyle(Color(.blueMain))
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 30))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    .padding(.leading, 30)
                    Spacer()
                }
                .padding(.top, -40)
                Spacer()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement : .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement : .topBarTrailing) {
                    Button {
                        Task {
                            try await viewModel.updateEdit()
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

#Preview {
    EditProfileView(user: User(id: UUID().uuidString, email: "doanvankhoan124@gmail.com", username: "simonisdev", fullname: "Doan Van Khoan"))
}
