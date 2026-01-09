//
//  ForgetPwd.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 05/01/26.
//

import SwiftUI

struct ForgetPwd: View {
    @State private var email = ""
    var body: some View {
            VStack{
                CustomTextFiled(
                    textTitle: "Email",
                    placeHolder: "Eneter Your Email",
                    text: $email)
                CustomButton(title: "Next", appIocn: nil) {
                    //Logic
                }.buttonStyle(PrimaryButtonStyle())
            }
            .padding()
            .navigationTitle("Forgot Passowrd")
            .navigationBarTitleDisplayMode(.inline)
                
    }
}

#Preview {
    ForgetPwd()
}
