//
//  CommentView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 29/4/24.
//

import SwiftUI


struct CommentDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let managerCache = CacheManager.shared
    let comment : Comment
    @StateObject private var viewModel = CommentDetailViewModel()
    
    var body : some View {
        NavigationStack {
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            if let imageUrl = viewModel.currentUser?.profileImageUrl {
                                if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                    Image(uiImage: cachedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .onAppear {
                                            print("using cache")
                                        }
                                } else {
                                    RemoteImage(url: imageUrl)
                                    .scaledToFit()
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
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            }
                            HStack(spacing : 0) {
                                VStack(alignment : .leading, spacing : 0) {
                                    Text(viewModel.currentUser?.fullname ?? "unknown")
                                        .fontWeight(.semibold)
                                    Text("@\(viewModel.currentUser?.username.lowercased() ?? "unknown")")
                                        .foregroundStyle(Color(.systemGray))
                                }
                                Spacer()
                                Button {
                                    
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .tint(.gray)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 40)
                        
                        VStack(alignment : .leading) {
                            Text(comment.content)
                                .multilineTextAlignment(.leading)
                                .font(.title3)
                            
                            if let imageUrl = comment.imageUrl {
                                if let cachedImage = managerCache.getImage(imageUrl: imageUrl) {
                                    Image(uiImage: cachedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(10)
                                        .onAppear {
                                            print("using cache")
                                        }
                                } else {
                                    RemoteImage(url: imageUrl)
                                    .scaledToFit()
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
                            }
                            
                            HStack {
                                HStack {
                                    Text(comment.create.formatted(date: .short, time: .short))
                                }
                                Spacer()
                            }
                            .foregroundStyle(Color(.systemGray))
                            .padding(.vertical, 10)
                            
                            Divider()
                            
                            HStack {
                                if viewModel.postObject?.reupload != 0 {
                                    Label {
                                        Text(viewModel.postObject?.reupload ?? 0 > 1 ? "Retweets" : "Retweet")
                                            .foregroundStyle(Color(.systemGray))
                                    } icon: {
                                        Text("\(viewModel.postObject?.reupload ?? 0)")
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                if viewModel.postObject?.likes != 0 {
                                    Label {
                                        Text(viewModel.postObject?.likes ?? 0 > 1 ? "Likes" : "Like")
                                            .foregroundStyle(Color(.systemGray))
                                            .contentTransition(.numericText(value: CGFloat(viewModel.postObject?.likes ?? 0)))
                                            .animation(.snappy, value: viewModel.postObject?.likes ?? 0)
                                    } icon: {
                                        Text("\(viewModel.postObject?.likes ?? 0)")
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                if viewModel.postObject?.comments != 0 {
                                    Label {
                                        Text("Quote Tweets")
                                            .foregroundStyle(Color(.systemGray))
                                    } icon: {
                                        Text("\(viewModel.postObject?.comments ?? 0)")
                                            .contentTransition(.numericText(value: CGFloat(viewModel.postObject?.comments ?? 0)))
                                            .animation(.snappy, value: viewModel.postObject?.comments ?? 0)
                                            .fontWeight(.semibold)
                                    }
                                }
                                Spacer()
                            }
                            
                            Divider()
                            
                            HStack {
                                buttonCommentDetail(icon: "message")
                                Spacer()
                                buttonCommentDetail(icon: "paperplane")
                                Spacer()
                                buttonCommentDetail(icon: "heart")
                                Spacer()
                                buttonCommentDetail(icon: "square.and.arrow.up")
                            }
                            .padding(.vertical, 5)
                            
                            Divider()
                            
                            if !viewModel.fakeComments.isEmpty {
                                ForEach(viewModel.fakeComments) { comment in
                                    VStack{
                                        CommentCellView(comment: comment)
                                        Divider()
                                    }
                                }
                            }
                            
                            if viewModel.commentsLoading {
                                ProgressView()
                            } else {
                                ForEach(viewModel.comments) { comment in
                                    VStack{
                                        CommentCellView(comment: comment)
                                        Divider()
                                    }
                                }
                            }
                            
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Comment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement : .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundStyle(Color.blueMain)
                }
            }
            .onAppear {
                
                viewModel.readValue(uidComment: comment.id)
                
                if !managerCache.getCommentLiked(uidComment: comment.id) {
                    if viewModel.checkedCacheLike == false {
                        viewModel.checkLikeOrNotLike(uidComment: comment.id)
                        viewModel.checkedCacheLike.toggle()
                    } else {
                        viewModel.checkedCacheLike.toggle()
                    }
                } else {
                    viewModel.stateLike = true
                }
                
//                Task {
//                    try await detailTweetViewModel.fetchComments(tweetUid: tweet?.id ?? "")
//                }
                
                Task {
                    try await viewModel.fetchUser(userUid: comment.ownerUid)
                }
            }
        }
    }
    
    
    @ViewBuilder
    func buttonCommentDetail(icon : String) -> some View {
        Button {
            if icon == "heart" {
                Task {
                    viewModel.setLikeOrUnlike(uidComment: comment.id)
                    
                    try await viewModel.updateLikeState(uidComment: comment.id)
                }
            }
            
//            if icon == "message" {
//                withAnimation {
//                    detailTweetViewModel.openComment.toggle()
//                }
//            }
        } label: {
            if icon == "heart" {
                Image(systemName: viewModel.stateLike == false ? icon : "heart.fill")
                    .font(.title2)
                    .symbolEffect(.bounce, value: viewModel.stateLike)
                    .contentTransition(.symbolEffect(.replace))
                    .foregroundStyle(viewModel.stateLike == false ? .black : .red)
            } else {
                Image(systemName: icon)
                    .font(.title2)
            }
        }
//        .frame(width : (UIScreen.main.bounds.width - 20) / 4 )
        .tint(.black)
        .opacity(0.6)
    }
}


#Preview {
    NavigationStack{
        CommentDetailView(comment: Comment(id: "qweqwe", ownerUid: "eqweqwe", create: Date.now, content: "Hello"))
    }
}
