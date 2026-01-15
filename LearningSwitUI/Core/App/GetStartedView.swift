//
//  GetStartedView.swift
//  LearningSwitUI
//
//  Created by Vishal Kothari on 13/01/26.
//

import SwiftUI

struct GetStartedView: View {
    @AppStorage("hasSeenGetStarted") private var hasSeenGetStarted: Bool = false
    var onGetStarted: () -> Void
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Color.white.frame(height: geo.size.height * 0.30)
                    Color.black.frame(height: geo.size.height * 0.7)
                }
                VStack(alignment:.center,spacing:30){
                    AutoScrollCarouselView()
                        .frame(width: geo.size.width*0.6,height:300)
                            .cornerRadius(40)
                            .shadow(radius: 4)
                      
                    Text("Grow Your app Insights with inspiring new")
                        .fontWeight(.semibold)
                        .font(.system(size: 34))
                    
                    Text("Explore thje world of analyzing vodeos nad new whwr mmhmjmjhm , ,j,j,,j,jk,j,jk,j,")
                        .fontWeight(.regular)
                        .font(.system(size: 24))
                        .lineLimit(4)
                    
                    Button {
                        onGetStarted()
                    } label: {
                        HStack{
                            Text("GET STARTED")
                                .fontWeight(.semibold)
                                .font(.title)
                            Spacer()
                            AppImage(source: .asset("Arrow"),width: 20,height: 20)
                        }.padding(30)
                    }.frame(maxWidth: .infinity)
                        .frame(height: 80)
                    .background(.red)
                    .cornerRadius(10)

                }
                .padding()
                .foregroundStyle(.white)
            }
               
        }.ignoresSafeArea()
    }
}

#Preview {
    GetStartedView(onGetStarted: {})
}

