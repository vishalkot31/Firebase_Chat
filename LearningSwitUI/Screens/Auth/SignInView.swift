//
//  SignInView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 02/01/26.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var pwd = ""
    @Environment(Router.self) private var router
    var body: some View {
            ScrollView {
                VStack(spacing:20) {
                    AppImage(source:.asset("AppLogo"),width: 150)
                        .padding(.top,60)
                    Text("SignIn")
                        .padding(.top,20)
                    CustomTextFiled(
                        textTitle: "Email",
                        placeHolder: "Enter Your Email",
                        securePwd: false, text: $email)
                    CustomTextFiled(
                        textTitle: "Password",
                        placeHolder: "Enter Your Password",
                        securePwd: true, image: "ShowPassord", text: $pwd)
                    
                    HStack{
                        Spacer()
                        CustomButton(title: "Forgot Passord ?", appIocn: nil) {
                            router.push(destination: .forgetPassord)
                        }
                    }
                    CustomButton(title: "Next", appIocn: nil) {
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    onDivide(text: "Or")
                    
                    CustomButton(title: "Continue with Apple", appIocn: "apple.logo") {
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .capsuleBorder(color: .gray)
                    
                    CustomButton(title: "Continue with Google", appIocn: "Google.logo") {
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .capsuleBorder(color: .black)
                    
                    CustomButton(
                        title: "Continue with Facebook",
                        appIocn: "Fb", type : false){
                            //Action
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                        .capsuleBorder(color: .black)
                    
                    Button("Create a Account"){
                        router.push(destination: .createAccount)
                    }.font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundStyle(Color.gray)
                
                }
                .padding(.horizontal,20)
            }.navigationBarBackButtonHidden()
        
        
    }
}


#Preview {
    SignInView().environment(Router())
}



