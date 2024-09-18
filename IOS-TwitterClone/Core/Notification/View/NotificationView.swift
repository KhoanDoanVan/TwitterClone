//
//  NotificationView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/5/24.
//

import SwiftUI


struct NotificationView: View {
    @Namespace var animate

    @StateObject private var viewModel = NotificationViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing : 0) {
                    ZStack {
                        HStack {
                            if let user = viewModel.user {
                                if let profileImage = user.profileImageUrl {
                                    RemoteImage(url: "\(profileImage)")
                                        .scaledToFill()
                                        .frame(width: 35, height: 35)
                                        .clipShape(Circle())
                                } else {
                                    ZStack{
                                        Image("imageProfile")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .cornerRadius(50)
                                    }
                                }
                            }
//                            Circle()
//                                .frame(width: 35)
                            Spacer()
                            Button {
                                
                            }label: {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        Text("Notificattions")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)

                    HStack(spacing : 0){
                        ForEach(NotificationFilter.allCases) { filter in
                            VStack {
                                Text(filter.title)
                                    .foregroundStyle(filter == viewModel.selectFilter ? .blueMain : .gray.opacity(0.9))
                                    .fontWeight(.bold)
                                
                                if(filter == viewModel.selectFilter) {
                                    Rectangle()
                                        .frame(width: UIScreen.main.bounds.width / 2, height: 2)
                                        .foregroundColor(.blueMain)
                                        .matchedGeometryEffect(id: "id", in: animate)
                                } else {
                                    Rectangle()
                                        .frame(width: UIScreen.main.bounds.width / 2, height: 2)
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectFilter = filter
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    if(NotificationFilter.all == viewModel.selectFilter) {
                        VStack {
                            ScrollView {
                                ForEach(viewModel.notifications) { notification in
                                    VStack {
                                        NotiCellView(notification: notification)
                                            .padding([.top,.bottom], 5)
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            viewModel.showSheet.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 60)
                                    .foregroundStyle(Color(.blueMain))
                                Image("createIcon")
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await viewModel.fetchNotifications()
            }
        }
        .sheet(isPresented: $viewModel.showSheet, content: {
            UploadView(user: viewModel.user)
                .padding(.top)
                .presentationCornerRadius(30)
        })
    }
}

#Preview {
    NotificationView()
}
