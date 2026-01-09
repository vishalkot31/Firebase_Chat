//
//  AppImage.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 08/01/26.
//

import Foundation
import SwiftUI


enum AppImageSource{
    case asset(String)
    case System(String)
}
struct AppImage:View {
    let source: AppImageSource
    var width: CGFloat = 40
    var height: CGFloat = 40
    
    private var image: Image {
           switch source {
           case .asset(let name):
               return Image(name)
           case .System(let name):
               return Image(systemName: name)
           }
       }
    var body: some View {
        image
       .resizable()
        .scaledToFit()
        .frame(width: width, height: height)
    }
}
