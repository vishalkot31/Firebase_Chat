//
//  UserDetailView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 15/01/26.
//

import SwiftUI

struct UserDetailView: View {
    let userId:Int
    var body: some View {
        Text(" User Id Detail \(userId)")
    }
}

#Preview {
    UserDetailView(userId: 1)
}
