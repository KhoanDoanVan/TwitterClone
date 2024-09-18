//
//  UploadVIew.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI
import Photos

struct UploadView: View {
    @Environment(\.dismiss) private var dismiss
    let user : User?
    
    @State private var selectedAction : ActionUploadType = .none
    
    @StateObject private var viewModel = UploadViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }
                        Spacer()
                        Button {
                            Task {
                                try await viewModel.createNewTweet()
                            }
                            dismiss()
                        } label: {
                            Text("Tweet")
                                .fontWeight(.semibold)
                                .padding(.vertical, 7)
                                .padding(.horizontal, 15)
                                .foregroundStyle(.white)
                                .background(.blueMain)
                                .cornerRadius(20)
                        }
                    }
                    HStack(alignment : .top){
                        if let profileImage = user?.profileImageUrl {
                            RemoteImage(url: "\(profileImage)")
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                        } else {
                            ZStack{
                                Image("imageProfile")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(50)
                            }
                        }
                        
                        VStack {
                            ZStack(alignment : .leading){
                                TextEditor(text: $viewModel.content)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                
                                VStack{
                                    Text("What's happened?")
                                        .foregroundStyle(Color(.systemGray))
                                    
                                    Spacer()
                                }
                                .opacity(viewModel.isWrite == false ? 1 : 0)
                                .padding()
                            }
                            .onTapGesture {
                                viewModel.isWrite = true
                                viewModel.showPickerFrame = false
                                selectedAction = .none
                            }
                            .frame(maxWidth: .infinity, maxHeight: 300)
                        }
                    }
                    HStack {
                        if viewModel.imagePreview != nil {
                            if viewModel.videoPreview != nil {
                                ZStack {
                                    Image(uiImage: viewModel.imagePreview!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                    Image(systemName: "video.fill")
                                        .foregroundStyle(.white)
                                }
                            } else {
                                Image(uiImage: viewModel.imagePreview!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ZStack{
                                Rectangle()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                    .foregroundStyle(Color(.systemGray3))
                                Rectangle()
                                    .frame(width: 99, height: 99)
                                    .cornerRadius(10)
                                    .foregroundStyle(.white)
                                Image(systemName: "camera")
                                    .font(.title)
                                    .foregroundStyle(Color.blueMain)
                            }
                            ForEach(0..<10) { _ in
                                Button {
                                    
                                } label: {
                                    Rectangle()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    Divider()
                    HStack {
                        HStack (spacing : 30){
                            buttonSheetUpload(icon: "image", action: .image)
                            buttonSheetUpload(icon: "gif", action: .gif)
                            buttonSheetUpload(icon: "stats", action: .stats)
                            buttonSheetUpload(icon: "location", action: .location)
                        }
                        Spacer()
                        HStack {
                            
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.fetchPhotos) { photo in
                                ZStack {
                                    Image(uiImage : photo.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height : 150)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            viewModel.videoPreview = nil
                                            if photo.asset.mediaType == .video {
                                                viewModel.getVideoFromAsset(asset: photo.asset) { video in
                                                    DispatchQueue.main.async {
                                                        viewModel.videoPreview = video
                                                    }
                                                }
                                            } else {
                                                viewModel.getImageFromAsset(asset: photo.asset, size: PHImageManagerMaximumSize) { image in
                                                    DispatchQueue.main.async {
                                                        viewModel.imagePreview = image
                                                    }
                                                }
                                            }
                                        }
                                    
                                    if photo.asset.mediaType == .video {
                                        Image(systemName: "video.fill")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                            .padding(8)
                                    }
                                }
                            }
                            
                            if viewModel.libraryStatus == .denied || viewModel.libraryStatus == .limited {
                                VStack {
                                    Text(viewModel.libraryStatus == .denied ? "Allow Access For Photos" : "Select More Photos")
                                        .foregroundStyle(Color(.systemGray))
                                    
                                    Button {
                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options : [:], completionHandler: nil)
                                    } label: {
                                        Text(viewModel.libraryStatus == .denied ? "Allow access" : "Select More")
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal)
                                            .background(Color(.blue))
                                            .cornerRadius(5)
                                    }
                                }
                                .frame(width : 150)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: viewModel.showPickerFrame ? 200 : 0)
                    .background(Color(.systemGray6))
                    .opacity(viewModel.showPickerFrame ? 1 : 0)
                }
            }
            
        }
    }
    
    @ViewBuilder
    func buttonSheetUpload(icon : String, action : ActionUploadType) -> some View {
        Button {
            switch(action) {
            case .image:
                withAnimation {
                    viewModel.openImagePicker()
                }
                if viewModel.showPickerFrame == false {
                    selectedAction = .none
                } else {
                    selectedAction = action
                }
            case .gif:
                selectedAction = action
            case .stats:
                selectedAction = action
            case .location:
                selectedAction = action
            case .none:
                selectedAction = action
            }
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(selectedAction == action ? Color(.systemGray5) : .white)
                    .cornerRadius(5)
                    
                Image(icon)
                    .foregroundStyle(Color.blueMain)
                    .font(.title3)
            }
        }
        .animation(.easeInOut, value: selectedAction)
    }
}

enum ActionUploadType {
    case image
    case gif
    case stats
    case location
    case none
}

#Preview {
    UploadView(user : User(id: UUID().uuidString, email: "doanvankhoan124@gmail.com", username: "Simonisdev", fullname: "Doan Van Khoan"))
}
