//
//  ForgetPwd.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 05/01/26.
//

import SwiftUI

struct ForgetPwd: View {
    @State private var email = ""
    @State private var viewModel = ForGotPwdVM()
    @Environment(Router.self) var router
    var body: some View {
            VStack{
                CustomTextFiled(
                    textTitle: "Email",
                    placeHolder: "Eneter Your Email",
                    text: $viewModel.email)
                CustomButton(title: "Next", appIocn: nil){
                    //Logic
                    viewModel.foregetPassord(router: router)
                }.buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.isFormvalid)
                    .opacity(viewModel.isFormvalid ? 1 : 0.5)
                if viewModel.isLoading {
                    ProgressView()
                }
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                }
            }
            .padding()
            .navigationTitle("Forgot Passowrd")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement:.topBarLeading) {
                    Button("Back"){
                        router.backScreen()
                    }
                }
            }
    }
}

#Preview {
    ForgetPwd().environment(Router())
}

