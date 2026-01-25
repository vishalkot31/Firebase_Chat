//
//  ChatListView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 17/01/26.
//

import SwiftUI
import FirebaseCore

struct ChatListView: View {
    
    @Bindable var viewModel = ChatListViewModel()
    @Environment(UserSession.self) private var session
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack {
            //SearchField
            SerachTextField(serachText: $viewModel.serachQuery)
                .padding(.horizontal)
            if viewModel.isLoading {
                ProgressView("Fecthing please wait")
            }
            else {
                if !viewModel.filteredChats.isEmpty {
                    List(viewModel.filteredChats){chat in
                        ChatListRow(chat: chat){
                            router.pushApp(destination:
                                .chatView(
                                id: chat.chat.otherUserId(
                                currentUserId: session.myUserID) ?? "",
                                otherName: chat.otherUserName
                            )
                        )
                    }
                }.listStyle(.plain)
                }
            }
        }.onAppear {
            viewModel.fetchListChats(userId: session.myUserID)
        }
    }
}


#Preview {
    ChatListView().environment(UserSession()).environment(Router())
}

//ChatList Row
struct ChatListRow:View {
    let chat : ChatListModel
    var tap:()->Void?
    var body: some View {
        HStack(alignment:.top,spacing:12){
           // CircularProfileImage(imageName: chat.avatar,size: 56)
            VStack(alignment:.leading){
                Text(chat.otherUserName)
                    .font(.system(size: 16,weight: .semibold))
                Spacer()
                Text(chat.chat.lastMessage)
                    .font(.system(size: 14,weight: .medium))
            }
            Spacer()
            VStack(alignment:.leading){
                Text(chat.chat.lastTimestampe.dateValue(),style: .time)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
        }.onTapGesture {
            tap()
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
