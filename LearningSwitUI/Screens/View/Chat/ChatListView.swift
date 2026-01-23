//
//  ChatListView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 17/01/26.
//

import SwiftUI

struct ChatListView: View {
    @State private var serachQuery:String = ""
    @State private var chats: [ChatModel] = []
    var filteredChat : [ChatModel] {
        if serachQuery.isEmpty{
            return chats
        }
        return chats
        .filter{$0.name.localizedCaseInsensitiveContains(serachQuery)}
    }
    
    var body: some View {
        VStack {
            //SearchField
            if !filteredChat.isEmpty {
                SerachTextField(serachText: $serachQuery)
                    .padding(.horizontal)
                List(filteredChat){chat in
                    ChatListRow(chat: chat)
                }.listStyle(.plain)
            }
           
        }
    }
}


#Preview {
    ChatListView()
}

//ChatList Row
struct ChatListRow:View {
    let chat : ChatModel
    var body: some View {
        HStack(alignment:.top,spacing:12){
            CircularProfileImage(imageName: chat.avatar,size: 56)
            VStack(alignment:.leading){
                Text(chat.name)
                    .font(.system(size: 16,weight: .semibold))
                Spacer()
                Text(chat.lastMessage)
                    .font(.system(size: 14,weight: .medium))
            }
            Spacer()
            VStack(alignment:.leading){
                Text(chat.lastTimestamp)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
        }
    }
}


//Circular imageview
struct CircularProfileImage:View {
    
    let imageName:String
    var size:CGFloat = 100
    var borderColor:Color = .blue
    var borderWidth:CGFloat = 3
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width:size, height: size)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(borderColor,lineWidth: borderWidth)
            }
    }
}


//Searchfiled

struct SerachTextField:View {
    @Binding var serachText:String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            TextField("Serach", text: $serachText)
                .textFieldStyle(.plain)
                .autocorrectionDisabled(true)
                .autocorrectionDisabled(true)
            //Show when there is text
            if !serachText.isEmpty{
                Button {
                    withAnimation {
                        serachText = "" //Empty the text on //tap
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }.transition(.scale)
            }
               
        }.padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 1)
        }
    }
}
