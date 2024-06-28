//
//  NewMessageView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 3/5/24.
//

import SwiftUI

struct NewMessageView: View {
    
    @StateObject private var viewModel = NewMessageViewModel()
    let managerCache = CacheManager.shared
    @Binding var openNewMessages : Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    ZStack{
                        TextField("Search for people and groups", text: $viewModel.searchText)
                            .padding(.trailing, 30)
                        if !viewModel.searchText.isEmpty {
                            HStack{
                                Spacer()
                                Button {
                                    viewModel.searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                }
                            }
                        }
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                .background(.gray.opacity(0.2))
                
                Spacer()
                
                ScrollView(.vertical) {
                    ForEach(viewModel.searchUsers) { user in
                        NavigationLink {
                            DetailChatView(userChat: user)
                        } label: {
                            VStack {
                                HStack {
                                    
                                    if let imageUrl = user.profileImageUrl {
                                        if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                            Image(uiImage: cachedImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                        } else {
                                            RemoteImage(url: imageUrl)
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                            .onAppear {
                                                let uiImageView = UIImageView()
                                                uiImageView.loadImage(from: imageUrl) { uiimage in
                                                    if let image = uiimage {
                                                        managerCache.addImage(imageUrl: imageUrl, values: image)
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        Image("imageProfile")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    }
                                    VStack(alignment : .leading){
                                        Text(user.fullname)
                                            .fontWeight(.semibold)
                                        Text("@\(user.username.lowercased())")
                                            .foregroundStyle(Color(.systemGray))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .foregroundStyle(.black)
                                .padding(.horizontal)
                                Divider()
                            }
                        }
                        .onTapGesture {
                            openNewMessages.toggle()
                        }
                    }
                    .onChange(of: viewModel.searchText) {
                        if viewModel.searchText.isEmpty {
                            viewModel.searchUsers = viewModel.users
                        } else {
                            viewModel.filterUserByKeySearch()
                        }
                    }
                }
            }
            .padding(.vertical)
            .navigationTitle("New message")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement : .topBarLeading) {
                    Button {
                        openNewMessages.toggle()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.black)
                    }
                }
            }
            .onAppear {
                Task {
                    viewModel.users = try await UserService.shared.fetchUsers()
                    viewModel.searchUsers = viewModel.users
                }
            }
        }
    }
}

//#Preview {
//    NewMessageView()
//}
