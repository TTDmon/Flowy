//
//  NewSeedView.swift
//  flowertell
//
//  Created by 天责 on 2023/6/1.
//

import SwiftUI

struct NewSeedView: View {
    @State private var offsetY: CGFloat = 300
    @EnvironmentObject var pathManager:PathManager
    @EnvironmentObject var flowerManager: FlowerManager
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                VStack{
                    Image("New-Label").scaledToFit()
                    Spacer()
                    ZStack{
                        Image("circle")
                        Text(flowerManager.newName).font(.largeTitle)
                    }
                    Text("送君\(flowerManager.newName)，愿君莫离")
                    Text("\"对我而言，你尽可放肆哭泣\"")
                    Image("\(flowerManager.newName)")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.2)
                        .glow(color: Color.white, radius: 50)
                        .offset(y: offsetY)
                        .animation(.easeInOut(duration: 1.0), value: offsetY)
                        .onAppear {
                            offsetY = 180
                        }
                }
                VStack{
                    Spacer()
                    HStack{
                        NavigationLink(value: 3) {
                            createButton(buttonName: "确认")
                        }.frame(width: 200)
                        Button {
                            pathManager.path.removeLast()
                        } label: {
                            Text("重置").frame(width:150)
                        }.buttonStyle(BorderButtonStyle())
                    }.padding()
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("Background2").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea())
        }
        
    }
}

struct NewSeedView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
