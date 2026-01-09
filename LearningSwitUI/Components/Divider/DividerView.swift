//
//  DividerView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 05/01/26.
//

import Foundation
import SwiftUI

struct onDivide:View {
    let text:String
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.5))

            Text(text)
                .font(.caption)
                .fontWeight(.heavy)
                .foregroundColor(.gray)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.vertical, 16)

    }
}
