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
    //for binding textfield
    @Binding var text:String
    //Toggle to show passord or not
    @State private var isPasswordVisible = false
    
    var body: some View {
        //Show text on top
        VStack(spacing:10){
            HStack{
                Text(textTitle)
                    .font(.headline)
                Spacer()
            }
            
            HStack{
                Group{
                    //If this is true show secure textfiled
                    if securePwd && !isPasswordVisible{
                        SecureField(placeHolder, text:$text)
                        }
                    //else show normal textfield
                    else{
                        TextField(placeHolder, text: $text)
                    }
                }
                
                //To show eye button
                
                if securePwd {
                    Button {
                        isPasswordVisible.toggle()
                        //toggle
                    } label: {
                        AppImage(
                            source: .System(isPasswordVisible ? "eye" : "eye.slash"),
                            width: 30,
                            height: 30
                        )
                    }

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
