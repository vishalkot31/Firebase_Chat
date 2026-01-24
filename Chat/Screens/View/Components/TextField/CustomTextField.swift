//
//  CustomTextField.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 05/01/26.
//

import Foundation
import SwiftUI

enum TextFieldType {
    case email
    case passsowrd
    case extra
}

//Custom Textfield
struct CustomTextFiled:View {
   
    let textTitle : String
    let placeHolder:String
    var typeTextFiled:TextFieldType = .extra
    var image = ""
    var leftImage:String?
    var isSystemImage = false
    //for binding textfield
    @Binding var text:String
    //Toggle to show passord or not
    @State private var isPasswordVisible = false
    //focus
    @FocusState private var isViewFocused:Bool
    
    var body: some View {
        //Show text on top
        VStack(spacing:10){
            HStack{
                Text(textTitle)
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing:10){
                Group{
                    //Left Image
                    if let image = leftImage{
                        AppImage(
                            source: isSystemImage ?
                                .System(image) : 
                                    .asset(image),
                            width: 20,
                            height: 20
                        )
                    }
                    //If this is true show secure textfiled
                    if typeTextFiled == .passsowrd && !isPasswordVisible{
                        SecureField(placeHolder, text:$text)
                            .focused($isViewFocused)
                    }
                    //else show normal textfield
                    else{
                        TextField(placeHolder, text: $text)
                            .focused($isViewFocused)
                            .autocorrectionDisabled(true)
                        
                    }
                    //Call right side view
                    rightSideView()
                }
                
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isViewFocused ?Color.red : Color.gray,lineWidth: 1)
            }
        }
    }
    

        //To show eye button and toggle
    @ViewBuilder func rightSideView()->some View{
        if typeTextFiled == .passsowrd {
            Button {
                isPasswordVisible.toggle()
                    //toggle
            } label: {
                AppImage(source: .System(isPasswordVisible ? "eye" : "eye.slash"),
                    width: 30,height: 30)
            }
        }
        else if typeTextFiled == .email && ValidationUtils.isValidEmail(text){
            AppImage(source: .asset("CheckMark"),width: 20,height: 20)
        }
    }
       
       
}
