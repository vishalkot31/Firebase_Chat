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
    @Environment(UserSession.self) private var session
    @State private var viewModel = CreateAccountVM(authService:AuthServiceFactory.makeAuthService(type: .custom))
    
    var body: some View {
            VStack(spacing:10) {
                AppImage(source:.asset("AppLogo"),width: 150)
                    .padding()
                Text("SignIn")
                    .padding(.top,10)
                CustomTextFiled(
                    textTitle: "Email",
                    placeHolder: "Eneter Your Email",
                    leftImage: "Email", text: $viewModel.email
                )
                CustomTextFiled(
                    textTitle: "Password",
                    placeHolder: "Enter Your Password",
                    typeTextFiled: .passsowrd, image: "ShowPassord", text: $viewModel.password)
                CustomButton(title: "Register", appIocn: nil) {
                    Task{
                        await viewModel
                            .register(userSession:session, router: router)
                    }
                   
                }.buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.isFormValid)
                    .opacity(viewModel.isFormValid ? 1 : 0.5)
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
                    router.backScreen()
                }.font(Constants.AppFonts.title)
                    .padding()
                    .foregroundStyle(Color.gray)
                
            }.padding()
             .navigationBarBackButtonHidden()//Hide navigation //abck button
             .loading(viewModel.isLoading)
             .appAlert($viewModel.alert)
    }
}

#Preview {
    CreateAccountView().environment(Router()).environment(UserSession())
}
