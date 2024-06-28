//
//  CommentCellView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 29/4/24.
//

import SwiftUI

struct CommentCellView: View {
    
    @StateObject private var viewModel = CommentCellViewModel()
    let comment : Comment
    let managerCache = CacheManager.shared
    
    var body : some View {
        NavigationLink {
            CommentDetailView(comment: comment)
        } label: {
            HStack(alignment : .top) {
                if let imageUrl = viewModel.user?.profileImageUrl {
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
                }
                
                VStack(alignment : .leading, spacing : 0) {
                    HStack {
                        Text(viewModel.user?.fullname ?? "")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                        Text("@\(viewModel.user?.username.lowercased() ?? "")")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(.systemGray))
                        Image(systemName: "circle.fill")
                            .foregroundStyle(Color(.systemGray))
                            .font(.system(size: 3))
                        Text(comment.create.timeAgoSinceNow(date : comment.create))
                            .font(.system(size: 15))
                            .foregroundStyle(Color(.systemGray))
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color(.systemGray))
                        }
                    }
                    
                    HStack(spacing : 5){
                        Text("Replying to")
                            .foregroundStyle(Color(.systemGray))
                        Button {
                            
                        } label: {
                            Text("@simonisdev")
                        }
                    }
                    
                    Text(comment.content)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 5)
                    
                    HStack {
                        buttonCommentCell(icon: "message", amount: viewModel.postObject?.comments ?? 0, action: .comment)
                        Spacer()
                        buttonCommentCell(icon: "paperplane", amount: viewModel.postObject?.reupload ?? 0, action: .reupload)
                        Spacer()
                        buttonCommentCell(icon: "heart", amount: viewModel.postObject?.likes ?? 0, action: .like)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .foregroundStyle(.primary)
                        .opacity(0.6)
                        Spacer()
                    }
                    .padding(.top, 10)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40)
            .onAppear {
                Task {
                    try await viewModel.fetchUser(userUid: comment.ownerUid)
                }
            }
        }
        .foregroundStyle(.primary)
        .onAppear {
            viewModel.readValue(uidComment: comment.id)
            
            if !managerCache.getCommentLiked(uidComment: comment.id) {
                if viewModel.checkCacheLiked == false {
                    viewModel.checkCommentLikedOrNot(uidComment: comment.id)
                    viewModel.checkCacheLiked.toggle()
                } else {
                    viewModel.checkCacheLiked.toggle()
                }
            } else {
                viewModel.likeState = true
            }
        }
    }
    
    @ViewBuilder
    func buttonCommentCell(icon : String, amount: Int, action : ActionTweet) -> some View {
        Button {
            switch action {
                
            case .like:
                Task {
                    withAnimation {
                        Task {
                            // set ui
                            viewModel.setLikeValueOrUnlike(uidComment: comment.id)
                            
                            // set database
                            try await viewModel.updateLikeDatabase(uidComment: comment.id)
                        }
                    }
                }
            case .comment:
                print("comment")
            case .reupload:
                print("reupload")
            }
        } label: {
            switch action {
            case .like:
                HStack(spacing : -5) {
                    Image(systemName: viewModel.likeState == false ? icon : "heart.fill")
                        .symbolEffect(.bounce, value: viewModel.likeState)
                        .contentTransition(.symbolEffect(.replace))
                        .foregroundStyle(viewModel.likeState == false ? .black : .red)
                    Text("\(amount)")
                        .foregroundStyle(viewModel.likeState == false ? .black : .red)
                        .contentTransition(.numericText(value: CGFloat(amount)))
                        .animation(.snappy, value: amount)
                        .frame(width: 35)
                }
            case .comment:
                HStack(spacing : -5) {
                    Image(systemName: icon)
                    Text("\(amount)")
                        .frame(width: 35)
                }
            case .reupload:
                HStack(spacing : -5) {
                    Image(systemName: icon)
                    Text("\(amount)")
                        .frame(width: 35)
                }
            }
        }
        .foregroundColor(.primary)
        .opacity(0.6)
    }
}

//#Preview {
//    CommentCellView()
//}
