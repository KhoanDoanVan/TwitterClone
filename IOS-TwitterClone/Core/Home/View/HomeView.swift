//
//  HomeView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var showMenu : Bool
    let user : User?
    @State private var showSheet : Bool = false
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HeaderHomeView(showMenu: $showMenu, user: user, viewModel : viewModel)
                    .opacity((viewModel.tweetDetail != nil) ? 0 : 1)
                
                TweetListView(viewModel : viewModel)
                    .opacity((viewModel.tweetDetail != nil) ? 0 : 1)
                
                if (viewModel.tweetDetail != nil) {
                    DetailTweet(viewModel: viewModel)
                        .frame(width : UIScreen.main.bounds.width - 20)
                }
                
                Spacer()
            }
            
            if(viewModel.tweetDetail == nil) {
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            showSheet.toggle()
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
        .sheet(isPresented: $showSheet, content: {
            UploadView(user: user)
                .padding(.top)
                .presentationCornerRadius(30)
        })
    }
}

#Preview {
    BaseView()
}
