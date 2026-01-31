//
//  ProfileSetupView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 18/01/26.
//

import SwiftUI

struct ProfileSetupView: View {
    
    @Environment(Router.self) private var router
    @Environment(UserSession.self) private var session
    @State private var vm = ProfileSetUpVM()
    
    // // ✅ Image states
    @State private var showImagePicker = false
    var body: some View {
        ScrollView() {
            VStack(spacing:30){
                ImageProfileView(image: vm.selectedImage) {
                    showImagePicker = true
                }
                CustomTextFiled(
                    textTitle: "Name (Required)",
                    placeHolder: "Enter your full name",leftImage: "person.circle", isSystemImage: true, text:$vm.fullName)
                CustomTextFiled(
                    textTitle: "User Name (Optional)",
                    placeHolder: "Choose a uique name",leftImage: "person.circle", isSystemImage: true, text:$vm.userNanme)
                BioTextView(textBio: $vm.bio)
                Spacer()
                CustomButton(title: "Continue", appIocn: nil){
                    Task{
                        await vm.saveDataToFirebase(router: router, sesion: session)
                    }
                }.buttonStyle(PrimaryButtonStyle())
                    .disabled(!vm.isvalidToGo)
                    .opacity(vm.isvalidToGo ? 1 : 0.5)
                
            }
        }.padding(.horizontal,15)
           //Add pickerview
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $vm.selectedImage)
            }
        //get userprfile link
            .onAppear{
                if let id = session.user?.id {
                    vm.loadProfile(id: id)
                }
            }
    }
}
//person.circle.fill
#Preview {
    ProfileSetupView().environment(Router()).environment(UserSession())
}

//Circular UserPrfile

struct ImageProfileView:View {
    let image: UIImage?
    let onUploadTap: () -> Void

    var body: some View {
        VStack(spacing:20){
            ZStack{
                Circle()
                    .fill(Color.blue.opacity(0.5))
                .frame(width: 100,height: 100)
                
                //Slected image or camera image
                if let image {
                      Image(uiImage: image)
                     .resizable()
                     .scaledToFill()
                     .frame(width: 100, height: 100)
                     .clipShape(Circle())
                    }
                else{
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30,height: 30)
                        .foregroundColor(.white)
                }

                // Layer 3: Upload button (bottom-right)
                VStack {
                    Spacer()
                        HStack {
                            Spacer()
                            FloatingIconButton(systemImage: "arrow.up") {
                                //Tap On button
                                onUploadTap()
                            }
                        }
                    }.frame(width: 128, height: 128)
            }
            Text("Add a profile Photo")
                .fontWeight(.semibold)
                .foregroundStyle(Color.gray)
        }
    }
}


struct FloatingIconButton: View {
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.blue)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: systemImage)
                        .foregroundColor(.white)
                )
        }
    }
}

//Bio TextView
struct BioTextView:View {
    @Binding var textBio:String
    var maxlength = 150
    var body: some View {
        VStack(alignment:.leading) {
            Text("Bio (Optional)")
            ZStack (alignment: .topLeading){
                TextEditor(text: $textBio)
                    .padding(.bottom)
                    .onChange(of: textBio) { oldValue, newValue in
                        if newValue.count > maxlength{
                            textBio = String(newValue.prefix(maxlength))
                        }
                    }
                    .autocorrectionDisabled(true)
                if textBio.isEmpty{
                    Text("Tell me about Youerself...")
                               .foregroundColor(.gray)
                               .padding(.horizontal, 12)
                               .padding(.vertical, 12)
                }
                // Character count at bottom-right
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text("\(textBio.count)/\(maxlength)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding([.trailing,.bottom],6)
                    }
                    
                }
               
            }
            .frame(height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}
