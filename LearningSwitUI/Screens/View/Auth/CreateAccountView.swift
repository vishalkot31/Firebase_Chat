//
//  CreateAccountView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 08/01/26.
//

import SwiftUI
import Observation

struct CreateAccountView: View {
    
    @State private var email = ""
    @Environment(Router.self) var router
    
    @State private var viewMdoel = CreateAccountVM()
    var body: some View {
            VStack(spacing:10) {
                AppImage(source:.asset("AppLogo"),width: 150)
                    .padding()
                Text("SignIn")
                    .padding(.top,10)
                CustomTextFiled(
                    textTitle: "Email",
                    placeHolder: "Eneter Your Email",
                    leftImage: "Email", text: $viewMdoel.email
                )
                CustomTextFiled(
                    textTitle: "Password",
                    placeHolder: "Enter Your Password",
                    securePwd: true, image: "ShowPassord", text: $viewMdoel.password)
                CustomButton(title: "Register", appIocn: nil) {
                    Task{
                        await viewMdoel.register(router: router)
                    }
                   
                }.buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewMdoel.isFormValid)
                    .opacity(viewMdoel.isFormValid ? 1 : 0.5)
                if viewMdoel.isLoading {
                    ProgressView()
                }
                if let error = viewMdoel.errorMessage {
                    Text(error)
                    .foregroundStyle(.red)
                }
                onDivide(text: "Or")
                
                CustomButton(title: "Continue with Apple", appIocn: "apple.logo") {
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .capsuleBorder(color: .gray)
                
                CustomButton(
                    title: "Continue with Google",
                    appIocn: "google",
                    type: false
                ) {
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .capsuleBorder(color: .black)
               
                CustomButton(title: "Continue with Facebook",
                            appIocn: "Fb", type : false){
                        //Action
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .capsuleBorder(color: .black)
                //
                Button("Already have a Account? Sign In"){
                    router.moveToRootScreen()
                }.font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(Color.gray)
                
            }.padding()
                .navigationBarBackButtonHidden()//Hide navigation //abck button
    }
}

#Preview {
    CreateAccountView().environment(Router())
}
