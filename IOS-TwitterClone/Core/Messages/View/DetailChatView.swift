//
//  DetailChatView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 4/5/24.
//

import SwiftUI
import PhotosUI

struct DetailChatView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DetailChatViewModel()
    let managerCache = CacheManager.shared
    let userChat: User?
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical) {
                    ScrollViewReader { proxy in
                        VStack {
                            ForEach(viewModel.messages, id: \.self) { message in
                                if message.fromId == viewModel.userCurrent?.id {
                                    HStack {
                                        Spacer()
                                        if message.imageUrl != nil {
                                            if let imageUrl = message.imageUrl {
                                                if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                                    Image(uiImage: cachedImage)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 200)
                                                        .cornerRadius(10)
                                                        .clipShape(Rectangle())
                                                } else {
                                                    RemoteImage(url: imageUrl)
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 200)
                                                        .cornerRadius(10)
                                                        .clipShape(Rectangle())
                                                        .onAppear {
                                                            let uiImageView = UIImageView()
                                                            uiImageView.loadImage(from: imageUrl) { uiimage in
                                                                if let image = uiimage {
                                                                    managerCache.addImage(imageUrl: imageUrl, values: image)
                                                                    
                                                                }
                                                            }
                                                        }
                                                }
                                            }
                                        } else {
                                            Text(message.content ?? "")
                                                .padding(.vertical, 3)
                                                .padding(.horizontal)
                                                .foregroundStyle(.white)
                                                .background(Color.blueMain)
                                                .cornerRadius(10)
                                        }
                                    }
                                } else {
                                    HStack {
                                        if message.imageUrl != nil {
                                            if let imageUrl = message.imageUrl {
                                                if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                                    Image(uiImage: cachedImage)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 200)
                                                        .cornerRadius(10)
                                                        .clipShape(Rectangle())
                                                } else {
                                                    RemoteImage(url: imageUrl)
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 200)
                                                        .cornerRadius(10)
                                                        .clipShape(Rectangle())
                                                        .onAppear {
                                                            let uiImageView = UIImageView()
                                                            uiImageView.loadImage(from: imageUrl) { uiimage in
                                                                if let image = uiimage {
                                                                    managerCache.addImage(imageUrl: imageUrl, values: image)
                                                                    
                                                                }
                                                            }
                                                        }
                                                }
                                            }
                                        } else {
                                            Text(message.content ?? "")
                                                .padding(.vertical, 3)
                                                .padding(.horizontal)
                                                .foregroundStyle(.black)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(10)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            
                            HStack{ Spacer() }
                                .id("fixed")
                        }
                        .onReceive(viewModel.$countStateScroll){ _ in
                            withAnimation {
                                proxy.scrollTo("fixed", anchor: .bottom)
                            }
                        }
                    }
                }
                .padding(.bottom, 5)
                VStack {
                    HStack(spacing : 10){
                        
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            Image("image")
                        }
                        
                        ZStack {
                            TextField("Write anything...", text: $viewModel.chatContent)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                                .padding(.trailing, 20)
                                .clipShape(Capsule())
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            HStack {
                                Spacer()
                                if !viewModel.chatContent.isEmpty || viewModel.imageMessage != nil {
                                    Button {
                                        Task {
                                            try await viewModel.sendMessage(toId: userChat?.id ?? "")
                                        }
                                    } label: {
                                        Image(systemName: "paperplane.fill")
                                    }
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                    }
                    
                    if let image = viewModel.imageMessage {
                        HStack {
                            ZStack {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            withAnimation {
                                                viewModel.imageMessage = nil
                                            }
                                        } label: {
                                            Image(systemName: "xmark.circle")
                                                .font(.title)
                                                .padding([.trailing, .top], -10)
                                                .foregroundStyle(Color.blueMain)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .frame(width: 100, height: 100)
                            Spacer()
                        }
                        .padding(.top, 5)
                    }
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement : .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                ToolbarItem(placement : .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        
                        if let imageUrl = userChat?.profileImageUrl {
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
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }

                        VStack(alignment : .leading) {
                            Text(userChat?.fullname ?? "")
                                .fontWeight(.semibold)
                            Text(userChat?.username.lowercased() ?? "")
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    try await viewModel.fetchAllMessagesFromUid(toId: userChat?.id ?? "")
                }
            }
        }
    }
}

//#Preview {
//    DetailChatView()
//}
