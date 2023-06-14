//
//  FlowerInfoView.swift
//  flowertell
//
//  Created by 天责 on 2023/5/30.
//

import SwiftUI

struct FlowerInfoView: View {
//    @EnvironmentObject var flowerManager: FlowerManager
    @State private var imagePosition = CGPoint.zero
    @State private var starNum: Int = 1
    @State private var newMessage = true
    @State private var starShowing = false
    @State private var isBlinking = false
    @State var selection: Int = 1
    @State var showchatView = false
    @State var currentFlower: String?
    
//    init(){
//        currentFlower = flowerManager.flower[flowerManager.currentIndex]
//    }
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                TabView(selection: $selection){
                    ZStack{
                        Image("level1").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
                    }.tag(1)
                        .onAppear{
                            imagePosition = randomPosition(in: geometry.size, center: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
                        }
                        .sheet(isPresented: $showchatView) {
                            ChatView()
                        }
                    ZStack{
                        Image("level2").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
                    }.tag(2)
                        .sheet(isPresented: $showchatView) {
                            ChatView()
                        }
                    ZStack{
                        Image("level3").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
                    }.tag(3)
                        .sheet(isPresented: $showchatView) {
                            ChatView()
                        }
                    ZStack{
                        Image("level4").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
                    }.tag(4)
                        .sheet(isPresented: $showchatView) {
                            ChatView()
                        }
                }
                .disabled(true)
                .ignoresSafeArea()
                .background(.black)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                if newMessage {
                    Button {
                        withAnimation {
                            self.starShowing.toggle()
                            self.newMessage.toggle()
                            self.showchatView.toggle()
                        }
                    } label: {
//                        Image("New")
//                            .animation(Animation.spring(response: 0.1, dampingFraction: 0.8, blendDuration: 0.5))
                        Image("New")
                    }
                    .scaleEffect(newMessage ? 1.0 : 0.1, anchor: .bottomTrailing)
                    .animation(.easeInOut(duration: 1.0), value: self.newMessage)
                    .position(x:100, y:200)
                }
                
                if !newMessage && starShowing && selection != 4{
                    Image("Star")
                        .scaleEffect(3)
                        .shadow(color: .black,radius: 10)
                        .opacity(isBlinking ? 1 : 0.5) // 控制透明度
                        .animation(.easeInOut(duration: 0.5), value: isBlinking)
                        .position(randomPosition(in: geometry.size, center: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)))
                        .onAppear {
                            // 创建一个无限循环的计时器
                            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                                withAnimation {
                                    self.isBlinking.toggle()
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                if self.selection != 4 {
                                    self.selection = self.selection + 1
                                    self.starNum = self.starNum + 1
                                    self.starShowing.toggle()
                                    self.newMessage.toggle()
                                }
                            }
                        }
                }
                
                VStack{
    //                Text(self.newMessage ? "message: 1" : "message: 0")
    //                Text(self.starShowing ? "star: 1" : "star: 0")
    //                Text("starnum: \(self.starNum)")
                    Spacer()
                    Text(Date(),style: .date).foregroundColor(.white).font(.largeTitle).shadow(color: .black,radius: 10)
                    HStack{
                        Image("Star")
                            .scaleEffect(starNum >= 1 ? 1.2 : 0.8)
                            .opacity(starNum >= 1 ? 1.0 : 0.3)
                            .padding()
                        Image("Star")
                            .scaleEffect(starNum >= 2 ? 1.2 : 0.8)
                            .opacity(starNum >= 2 ? 1.0 : 0.3)
                            .padding()
                        Image("Star")
                            .scaleEffect(starNum >= 3 ? 1.2 : 0.8)
                            .opacity(starNum >= 3 ? 1.0 : 0.3)
                            .padding()
                        Image("Star")
                            .scaleEffect(starNum >= 4 ? 1.2 : 0.8)
                            .opacity(starNum >= 4 ? 1.0 : 0.3)
                            .padding()
                    }
                    .shadow(color: .black,radius: 10)
                }.foregroundColor(.white)
            }
        }
        }
        
    
    func randomPosition(in size: CGSize, center: CGPoint) -> CGPoint {
        let range: CGFloat = 50
        let x = CGFloat.random(in: center.x - range ... center.x + range)
        let y = CGFloat.random(in: center.y - range ... center.y + range)
        return CGPoint(x: x, y: y)
    }
}

struct FlowerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FlowerInfoView()
    }
}
