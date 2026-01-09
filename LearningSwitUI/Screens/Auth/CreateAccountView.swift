//
//  CreateAccountView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 08/01/26.
//

import SwiftUI

struct CreateAccountView: View {
    
    @State private var email = ""
    var body: some View {
            VStack(spacing:20) {
                AppImage(source:.asset("AppLogo"),width: 150)
                    .padding()
                Text("SignIn")
                    .padding(.top,20)
                CustomTextFiled(
                    textTitle: "Email",
                    placeHolder: "Eneter Your Email",
                    text: $email
                )
                CustomButton(title: "Next", appIocn: nil) {
                    //Logic
                }.buttonStyle(PrimaryButtonStyle())
                
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
                    
                    
                
                NavigationLink {
                    SignInView()
                } label: {
                    Text("Already have a Account? Sign In")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundStyle(Color.gray)
                }
                
            }.padding()
                .navigationBarBackButtonHidden()//Hide navigation abck button
    }
}

#Preview {
    CreateAccountView()
}
