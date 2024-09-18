//
//  ListView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 16/04/2024.
//

import SwiftUI

// Tesst error

struct ListView: View {
    @Namespace var animation
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFilter: ListsTwitterFilter = .subscribedTo
    
    private var widthComponents: CGFloat = CGFloat( UIScreen.main.bounds.width / CGFloat(ListsTwitterFilter.allCases.count) )
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack(spacing: 0) {
                        ForEach(ListsTwitterFilter.allCases) { item in
                            VStack {
                                Text(item.title)
                                    .font(.subheadline)
                                    .foregroundStyle(selectedFilter == item ? Color.blue : Color(.systemGray))
                                    .bold()
                                
                                if selectedFilter == item {
                                    Rectangle()
                                        .frame(width: widthComponents, height: 2)
                                        .foregroundStyle(Color.blue)
                                        .matchedGeometryEffect(id: "item", in: animation)
                                } else {
                                    Rectangle()
                                        .frame(width: widthComponents, height: 2)
                                        .foregroundStyle(Color(.white))
                                }
                                    
                            }
                            .frame(maxWidth: widthComponents)
                            .onTapGesture {
                                withAnimation {
                                    selectedFilter = item
                                }
                            }
                        }
                    }
                    Spacer()
                    
                    VStack {
                        Spacer()
                        VStack {
                            Text("You haven't created or subscribed to any Lists")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("When you do, it'll show up here.")
                                .foregroundStyle(Color(.systemGray))
                            
                            Button {
                                
                            } label: {
                                Text("Create a List")
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        Spacer()
                    }
                    .foregroundStyle(.black)
                    .ignoresSafeArea()
                }
                                
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 60)
                                    .foregroundStyle(Color(.blueMain))
                                Image(systemName: "doc.badge.plus")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Lists")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    buttonBack()
                }
            }
        }
    }
    
    
    private func buttonBack() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
        }
    }
}

#Preview {
    ListView()
}
