//
//  MessageSettingsView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 4/5/24.
//

import SwiftUI

struct ToggleSettings {
    var receiveAnyone : Bool? = false
    var qualityFilter : Bool? = false
    var readReceipts : Bool? = false
}

struct MessageSettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var receiveAnyone : Bool = false
    @State private var qualityFilter : Bool = false
    @State private var readReceipts : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment : .leading){
                Text("Privacy")
                    .padding()
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.gray)
                    .background(Color.gray.opacity(0.2))
                    .padding(.top)
                
                VStack {
                    fieldToggleSettings(title: "Receive messages from anyone", descriptions: "You will be able to receive Direct Message requests from anyone on Twitter, even if you don't follow them.", state: $receiveAnyone)
                        .padding(.horizontal)
                    Divider()
                    fieldToggleSettings(title: "Quality filter", descriptions: "Filters lower-quality messages from your Direct Message requests.", state: $qualityFilter)
                        .padding(.horizontal)
                    Divider()
                    fieldToggleSettings(title: "Show read receipts", descriptions: "When someone sends you a message, people in the conversation will know when you've seen it.If you turn off this setting, you won't be able to see read receipts from others", state: $readReceipts)
                        .padding(.horizontal)
                }
                .background(.white)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("Messages settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement : .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.primary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func fieldToggleSettings(title : String, descriptions : String, state : Binding<Bool>) -> some View {
        VStack(alignment: .leading) {
            Toggle("Receive messages from anyone", isOn: state)
                .fontWeight(.semibold)
            Text(descriptions)
                .font(.footnote)
                .foregroundStyle(Color.gray)
            Button {
                
            } label: {
                Text("Learn more")
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    MessageSettingsView()
}
