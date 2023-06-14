//
//  StartView.swift
//  flowertell
//
//  Created by 天责 on 2023/6/6.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var ls: Int = 0
    let imageModels = ["LS1", "LS2", "LS3", "LS4"]
    var body: some View {
        ZStack{
            TabView(selection: $ls) {
                ForEach(imageModels.indices) { index in
                    ZStack{
                        Image(imageModels[index])
                            .resizable()
                            .scaleEffect(1.1)
                            .scaledToFill()
                            .animation(.easeInOut(duration: 1.0), value: ls)
                    }.tag(index)
                }

            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .background(Color(.black))
            .tabViewStyle(PageTabViewStyle())
            .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    if ls != 3 {
                        Button {
                            withAnimation {
                                ls = ls+1
                            }
                        } label: {
                            Image("right")
                        }
                    }else{
                        Button {
                            withAnimation {
                                viewRouter.currentView = .view2
                            }
                        } label: {
                            Image("right")
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
