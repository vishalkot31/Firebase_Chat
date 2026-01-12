//
//  PrimaryButtonStyle.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 05/01/26.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle :ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(Color.blue)
            .cornerRadius(10)
    }
}


struct CustomButton:View {
    //
    let title:String
    let appIocn : String?
    var type = true
    let action : ()->Void
    var body: some View {
        Button(action: action) {
            HStack(spacing:20){
                if let icon = appIocn{
                    AppImage(source: type ? .System(icon) : .asset(icon))
                }
                Text(title)
            }
        }
        .padding(.vertical,5)
    }
}

