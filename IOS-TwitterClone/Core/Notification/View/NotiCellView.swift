//
//  LikeNotiCellView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 2/6/24.
//

import SwiftUI

enum NotificationType: Decodable, Encodable {
    case like, retweet, comment, follow
}

struct NotiCellView: View {
    
    let notification: Notification
    
    @StateObject var viewModel = NotiCellViewModel()
    
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            iconNotification(notification: notification)
            
            VStack(alignment: .leading) {
                if(notification.type != .follow) {
                    
                    if let user = viewModel.fromIdUser {
                        if let profileImage = user.profileImageUrl {
                            RemoteImage(url: "\(profileImage)")
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            ZStack{
                                Image("imageProfile")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(50)
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading){
                    HStack(spacing: 5){
                        Text(viewModel.fromIdUser?.fullname ?? "")
                            .fontWeight(.bold)
                        typeOfTextNotification(notification: notification)
                    }
                    
                    contentOfNotification(notification: notification)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            Task {
                try await viewModel.fetchUser(userId:notification.fromId)
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func iconNotification(notification: Notification) -> some View {
        switch(notification.type) {
        case .comment:
            Image(systemName: "paperplane.fill")
                .font(.system(size: 30))
                .foregroundStyle(.gray)
        
        case .like:
            Image(systemName: "heart.fill")
                .font(.system(size: 30))
                .foregroundStyle(.red)
        case .retweet:
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 30))
                .foregroundStyle(.green)
        case .follow:
            Image(systemName: "person.fill")
                .font(.system(size: 30))
                .foregroundStyle(.blue)
        }
    }
    
    @ViewBuilder
    func typeOfTextNotification(notification: Notification) -> some View {
        switch(notification.type) {
        case .comment:
            Text("comment your Tweet")
                .lineLimit(1)
        case .like:
            Text("liked your Tweet")
                .lineLimit(1)
        case .retweet:
            Text("retweet your Tweet")
                .lineLimit(1)
        case .follow:
            Text("followed you")
                .lineLimit(1)
        }
    }
    
    @ViewBuilder
    func contentOfNotification(notification: Notification) -> some View {
        switch(notification.type) {
        case .comment:
            Text(notification.content ?? "unknown")
                .lineLimit(1)
                .font(.callout)
                .opacity(0.6)
                .padding(.top, 5)
        case .like:
            Text(notification.content ?? "unknown")
                .font(.callout)
                .opacity(0.6)
                .padding(.top, 5)
        case .retweet:
            Text("The color that is amazing right, did you love that? I don't know ahihi")
                .font(.callout)
                .opacity(0.6)
                .padding(.top, 5)
        case .follow:
            VStack(alignment: .leading){
                HStack {
                    
                    if let user = viewModel.fromIdUser {
                        if let profileImage = user.profileImageUrl {
                            RemoteImage(url: "\(profileImage)")
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            ZStack{
                                Image("imageProfile")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(50)
                            }
                        }
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Follow back")
                            .fontWeight(.bold)
                            .font(.footnote)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .clipShape(Capsule())
                            .background(.blueMain)
                            .foregroundStyle(.white)
                            .cornerRadius(15)
                    }
                }
                
                Text(viewModel.fromIdUser?.fullname ?? "")
                    .fontWeight(.bold)
                Text("@\(viewModel.fromIdUser?.username ?? "")")
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
                Text("Gadgets for you")
                    .font(.callout)
            }
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.gray).opacity(0.5), lineWidth : 1)
            }
        }
    }
}

#Preview {
    NotiCellView(notification: Notification(id: UUID().uuidString, toId: UUID().uuidString, fromId: UUID().uuidString, type: .like))
}
