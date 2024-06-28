//
//  MessageView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 3/5/24.
//

import SwiftUI

struct MessageView: View {
    
    @StateObject private var viewModel = MessageViewModel()
    private let managerCache = CacheManager.shared
    let user : User?
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        Text("Messages")
                            .fontWeight(.bold)
                        HStack {
                            if let imageUrl = user?.profileImageUrl {
                                if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                    Image(uiImage: cachedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    RemoteImage(url: imageUrl)
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
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
                                    .frame(width:40, height: 40)
                                    .cornerRadius(50)
                            }
                            
                            Spacer()
                            NavigationLink {
                                MessageSettingsView()
                            } label: {
                                Image(systemName: "gearshape")
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    TextField("Search for people and groups", text: $viewModel.searchText)
                        .clipShape(Capsule())
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .onChange(of: viewModel.searchText) {
                            viewModel.filterRecentMessageByKeySearch()
                        }
                    
                    Divider()
                    
                    ScrollView(.vertical) {
                        ForEach(viewModel.searchText.isEmpty ? viewModel.recentMessages : viewModel.searchRecentMessages) { recentMessage in
                            NavigationLink {
                                DetailChatView(userChat: recentMessage.user)
                            } label: {
                                VStack{
                                    HStack(alignment : .top) {
                                        if let imageUrl = recentMessage.user?.profileImageUrl {
                                            if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                                Image(uiImage: cachedImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 70, height: 70)
                                                    .clipShape(Circle())
                                            } else {
                                                RemoteImage(url: imageUrl)
                                                    .scaledToFill()
                                                    .frame(width: 70, height: 70)
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
                                                .frame(width:70, height: 70)
                                                .cornerRadius(50)
                                        }

                                        VStack(alignment : .leading){
                                            HStack(spacing: 0) {
                                                HStack(spacing: 5){
                                                    Text(recentMessage.user?.fullname ?? "")
                                                        .font(.system(size: 15))
                                                        .fontWeight(.semibold)
                                                    Text("@\(recentMessage.user?.username.lowercased() ?? "")")
                                                        .font(.system(size: 15))
                                                        .foregroundStyle(Color(.systemGray))
                                                }
                                                Spacer()
                                                Text(recentMessage.timestamp.timestampString())
                                                    .foregroundStyle(Color(.systemGray))
                                            }
                                            
                                            if recentMessage.content.isEmpty {
                                                Image(systemName: "photo")
                                                    .foregroundStyle(Color(.systemGray))
                                            } else {
                                                Text(recentMessage.content)
                                                    .lineLimit(2)
                                                    .foregroundStyle(Color(.systemGray))
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment : .leading)
                                    }
                                    Divider()
                                        .opacity(0.5)
                                }
                                .padding(.horizontal)
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                    
                    Spacer()
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewModel.openNewMessages.toggle()
                        }label: {
                            ZStack{
                                Circle()
                                    .frame(width: 60)
                                    .foregroundStyle(Color.blueMain)
                                Image("emailPlus")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.openNewMessages, content: {
                NewMessageView(openNewMessages : $viewModel.openNewMessages)
            })
        }
    }
}

//#Preview {
//    MessageView()
//}
