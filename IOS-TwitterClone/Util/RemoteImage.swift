//
//  RemoteImage.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 17/04/2024.
//

import Foundation
import SwiftUI

struct RemoteImage: View {
    let url: String
    @State private var isLoading = false

    var body: some View {
        
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                
                if !isLoading {
                    ProgressView()
                }
            case .success(let image):
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        if isLoading == false {
                            DispatchQueue.main.async {
                                isLoading = true
                            }
                        }
                    }
            case .failure:
                
                Button {
                    DispatchQueue.main.async {
                        isLoading = true
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                }
                .onAppear {
                    if isLoading == false {
                        DispatchQueue.main.async {
                            isLoading = true
                        }
                    }
                }
            @unknown default:
                
                EmptyView()
            }
        }
    }
}

//import Foundation
//import SwiftUI
//
//struct RemoteImage: View {
//    let url: String
//    @State private var isLoading = false
//
//    var body: some View {
//        // Use an asynchronous image loader
//        AsyncImage(url: URL(string: url)) { phase in
//            switch phase {
//            case .empty:
//                // Placeholder or loading state
//                if isLoading {
//                    ProgressView()
//                } else {
//                    Button(action: {
//                        // Reload button action
//                        isLoading = true
//                    }) {
//                        Image(systemName: "arrow.counterclockwise.circle")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .foregroundColor(.white)
//                    }
//                }
//            case .success(let image):
//                // Successfully loaded image
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .onAppear {
//                        isLoading = false
//                    }
//            case .failure:
//                // Error state
//                Button(action: {
//                    // Retry button action
//                    isLoading = true
//                }) {
//                    Image(systemName: "arrow.counterclockwise.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .foregroundColor(.white)
//                }
//                .onAppear {
//                    isLoading = false
//                }
//            @unknown default:
//                // Handle unknown cases
//                EmptyView()
//            }
//        }
//    }
//}

