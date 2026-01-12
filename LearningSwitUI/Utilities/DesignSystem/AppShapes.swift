//
//  AppShapes.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 05/01/26.
//

import Foundation
import SwiftUI

enum AppShape{
    static let capsule =  Capsule()
    static let conreRadius:CGFloat = 12
}

struct CapsuleBorderModifier:ViewModifier{
    var borderColor: Color = .gray
    var lineWidth: CGFloat = 1

    func body(content:Content)->some View{
        content
            .overlay {
                AppShape.capsule
                    .stroke(borderColor,lineWidth: lineWidth)
            }
    }
}

extension View {
    func capsuleBorder(color: Color = .gray,lineWidth: CGFloat = 1) -> some View {
        self.modifier(
            CapsuleBorderModifier(borderColor: color, lineWidth: lineWidth)
        )
    }
}
