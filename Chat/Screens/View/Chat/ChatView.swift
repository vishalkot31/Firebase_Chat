//
//  ChatView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 21/01/26.
//

import SwiftUI
import FirebaseCore

struct ChatView: View {
    
    @Environment(Router.self) private var router
    @Environment(UserSession.self) private var session
    
    @StateObject private var vm: ChatViewModel
    
    ///Pass this to information
    let otherUserId:String
    var otherUserName:String
    
    //Intalizing view need sto pass values 
    init(otherId: String,otherName:String) {
        self.otherUserId = otherId
        self.otherUserName = otherName
        _vm = StateObject(wrappedValue:ChatViewModel(otherId: otherId))
    }
   
   
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView{
                LazyVStack(spacing:20) {
                    ForEach(vm.messages){ chat in
                        ChatBubble(chat: chat, currentUserId: session.myUserID)
                        .id(chat.id)
                        }
                   }.padding()
                    //On button tap
                }.onChange(of: $vm.messages.count) {
                    if let last = $vm.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    SendView(msg: $vm.txtMsg) {
                        //send message
                        vm.sendMessage()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                }
        }.onAppear{
            vm.injectMyUserID(session.myUserID)
        }
        .navigationTitle(otherUserName)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    
    struct SendView:View {
        @Binding var msg:String
        var sendMessage : (()-> Void)
        var body: some View {
            HStack{
                TextField("Type a Message", text: $msg)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                .disabled(msg.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
    
    
    struct ChatBubble:View {
        var chat:MessageModel
        let currentUserId: String
        var isFromUser:Bool{
            chat.senderID == currentUserId
        }
        var body: some View {
            VStack(){
                HStack{
                    if isFromUser{
                        Spacer()
                    }
                    VStack(alignment:.leading,spacing: 5) {
                        Text(chat.message)
                        Text(chat.timestamp.dateValue(),style: .time)
                            .font(.caption2)
                    }
                    .padding(8)
                    .foregroundStyle(isFromUser ? Color.white : Color.gray)
                    
                    .background(  RoundedRectangle(cornerRadius: 9).fill(isFromUser ? Color.blue : Color.white))
                    .overlay {
                        RoundedRectangle(cornerRadius:9)
                            .stroke(lineWidth: 1)
                    }
                    if !isFromUser{
                        Spacer()
                    }
                }
                
            }
        }
    }
}

//#Preview {
//    let session = UserSession()  // create a session instance for preview
//    
//    ChatView(
//        otherUserModel: UserModel(
//            id: "preview_user_2",
//            email: "preview@test.com",
//            displayName: "PreviewUser",
//            profileImageURL: nil,
//            createdAt: Date(),
//            isProfileCompleted: true,
//            bio: "This is a preview bio",
//            fullName: "Preview User"
//        ),
//        // pass session
//    )
//    .environment(Router())
//    .environment(session)
//}


