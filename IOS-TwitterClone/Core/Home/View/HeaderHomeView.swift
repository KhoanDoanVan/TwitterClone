//
//  HeaderHomeView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI

struct HeaderHomeView: View {
    
    @Binding var showMenu : Bool
    let user : User?
    @StateObject var viewModel : HomeViewModel
    private let managerCache = CacheManager.shared
    
    var body: some View {
        VStack(spacing : 0){
            ZStack {
                HStack {
                    Button {
                        withAnimation {
                            showMenu.toggle()
                        }
                    } label: {
                        
                        if let imageUrl = user?.profileImageUrl {
                            if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                Image(uiImage: cachedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                                    .onAppear {
                                        print("using cache")
                                    }
                            } else {
                                RemoteImage(url: imageUrl)
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
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
                                .frame(width:50, height: 50)
                                .cornerRadius(50)
                        }
                    }
                    Spacer()
                    Button {
                        Task {
                            TweetService.lastDocumentSnapshot = nil
                            viewModel.tweets = []
                            try await viewModel.initialize()
                        }
                    } label: {
                        Image(systemName: "lasso.badge.sparkles")
                    }
                }
                Image("twitterTinny")
            }
            .padding()
            Divider()
        }
        .frame(width: (viewModel.tweetDetail != nil) ? 0 : .infinity, height: (viewModel.tweetDetail != nil) ? 0 : .infinity)
    }
}

#Preview {
    BaseView()
}
