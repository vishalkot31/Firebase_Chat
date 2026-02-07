//
//  SignInView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 02/01/26.
//

import SwiftUI

struct SignInView: View {
//    @State private var email = ""
//    @State private var pwd = ""
    @State private var showErrorAlert = false
    
    @Environment(Router.self) private var router
    @Environment(UserSession.self) private var session
    
    //Add dependecy
    @State private var viewModel = AuthViewModel(
        authService: AuthServiceFactory.makeAuthService(type: .custom))
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing:10) {
                    AppImage(source:.asset("AppLogo"),width: 150)
                        .padding(.top,40)
                    Text("SignIn")
                        .padding(.top,10)
                    CustomTextFiled(
                        textTitle: "Email",
                        placeHolder: "Enter Your Email",
                        typeTextFiled: .email, leftImage: "Email", text: $viewModel.email)
                    CustomTextFiled(
                        textTitle: "Password",
                        placeHolder: "Enter Your Password",
                        typeTextFiled: .passsowrd, image: "ShowPassord", leftImage: "password", text: $viewModel.password)
                    HStack{
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray,lineWidth: 1)
                            .frame(width: 20,height: 20)
                        HStack{
                            Text(!viewModel.isFormvalid ? "Keep me signed In" :"Remember me")
                        }
                        Spacer()
                        CustomButton(title: "Forgot Passord ?", appIocn: nil) {
                            router.push(destination: .forgetPassord)
                        }
                    }
                    CustomButton(title: "Login", appIocn: nil) {
                        //Login Logic
                        Task{
                            await viewModel
                                .login(router: router, session: session)
                        }
                       
                        
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.isFormvalid)
                    .opacity(viewModel.isFormvalid ? 1 : 0.5)
                    
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
                    
                    CustomButton(title: "Continue with Facebook",appIocn: "Fb", type : false){
                        //Action
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .capsuleBorder(color: .black)
                    
                    Button("Create a Account"){
                        router.push(destination: .createAccount)
                    }.font(Constants.AppFonts.title)
                        .padding()
                        .foregroundStyle(Color.gray)
                    
                }
                .padding(.horizontal,20)
            }.navigationBarBackButtonHidden()
            
            
        }
    }
}


#Preview {
    SignInView().environment(Router()).environment(UserSession())
}



