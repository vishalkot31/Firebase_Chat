//
//  CustomTextField.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 05/01/26.
//

import Foundation
import SwiftUI


//Custom Textfield
struct CustomTextFiled:View {
    let textTitle : String
    let placeHolder:String
    var securePwd = false
    var image = ""
    @Binding var text:String
    var body: some View {
        VStack(spacing:12){
            HStack{
                Text(textTitle)
                    .font(.headline)
                Spacer()
            }
            Group{
                if securePwd{
                    HStack{
                        SecureField(placeHolder, text:$text)
                        AppImage(source: .asset(image),width: 20,height: 20)
                    }
                }
                else{
                    TextField(placeHolder, text: $text)
                }
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray,lineWidth: 1)
            }
        }
    }
}
