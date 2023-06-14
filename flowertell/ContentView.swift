//
//  ContentView.swift
//  flowertell
//
//  Created by 天责 on 2023/5/24.
//

import SwiftUI

class PathManager:ObservableObject{
    @Published var path = NavigationPath()
}

class FlowerManager: ObservableObject{
    enum flowerType{
        case Sunflower
        case Jasmine
        case Rose
        case Tulip
        case Hydrongea
        case Iris
    }
    struct flowerinfo {
        var name: String?
        var motto: String?
    }
    @Published var motto: String = "nil"
    @Published var currentIndex: Int = 4
    @Published var flow = [flowerinfo]()
    @Published var flower = [String]()
    @Published var new: Int?
    @Published var newName: String = "Iris"
    var photos = ["Iris","Sunflower", "Molly", "Jasmine", "Rose", "Tulip", "Hydrangea", "Lily", "Iris" ]
    init(){
        flower.append(contentsOf: photos)
        new = -1
    }
}

struct ContentView: View {
    @StateObject var flowerManager = FlowerManager()
    @ObservedObject var viewModel = ViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    @State var tabViewSelected: Int = 2
    @StateObject var pathManager = PathManager()
    var body: some View {
        NavigationStack(path: $pathManager.path){
            TabView(selection: $tabViewSelected){
                //第一个选项卡
                VStack(){
                    Image("Meet-Label").scaledToFill()
                    ScrollView(.vertical){
                        VStack{
                            ForEach(1..<5){index in
                                MessageView(index:index).scaledToFit().padding()
                            }
                        }
                    }
                }
                .tag(1)
                .foregroundColor(.white).tabItem {
                    if tabViewSelected == 1 {
                        Image("Tab-Explore").glow(color: .white, radius: 10)
                    }
                    else {
                        Image("Tab-Explore")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Image("Background").resizable().aspectRatio(contentMode: .fill))
                
                //第二个选项卡
                VStack(){
                    Image("Flower-Label").scaledToFill()
                    Spacer()
                    flowerSelectView().scaledToFit()
                    Text("今天感觉怎么样？来创建新的花种吧！").font(.title2)
                    NavigationLink(value: 1) {
                        createButton(buttonName: "新建")
                    }
                    Spacer()
                }
                .tag(2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Image("Background").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea())
                .foregroundColor(.white)
                .tabItem {
                    if tabViewSelected == 2 {
                        Image("Tab-New").glow(color: .white, radius: 10)
                    }
                    else {
                        Image("Tab-New")
                    }
                }
                
                //第三个选项卡
                VStack(){
                    HStack{
                        NavigationLink(destination: SettingView()) {
                            Image("Settings")
                        }
                        Spacer()
                        Image("Home-Label").scaledToFill()
                        Spacer()
                        Image("ScanCode")
                    }
                    Spacer()
                    Image("UserInfo").resizable().scaledToFit()
                }
                .tag(3)
                .foregroundColor(.white)
                .tabItem {
                    if tabViewSelected == 3 {
                        Image("Tab-Home").glow(color: .white, radius: 10)
                    }
                    else {
                        Image("Tab-Home")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Image("Background").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea())
                
            }
            .navigationDestination(for: Int.self) { target in
                            switch target {
                            case 1:
                                CreateView()
                            case 2:
                                NewSeedView()
                            case 3:
                                ListeningView()
                            case 4:
                                gptView()
                            case 5:
                                FlowerInfoView()
                            default:
                                ContentView()
                            }
                        }
        }
        .ignoresSafeArea()
        .environmentObject(viewModel)
        .environmentObject(pathManager)
        .environmentObject(flowerManager)
        .onAppear{
            viewModel.setup()
        }
        .onDisappear{
            flowerManager.new = -1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BorderButtonStyle: ButtonStyle { //给button设置style
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .overlay(
                        Capsule()
                            .stroke(Color.white, lineWidth: 2)
                    )
            )
    }
}

struct createButton: View{ //用zstack来装一个text和rectangle来表示一个view类型的输出，当作button的形状
                                //再在navigationlink里用该view类型来表示button
    var buttonName: String
    var body: some View{
        ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.gray.opacity(0.5)) // 添加半透明灰色背景
                        .frame(width: 200, height: 50)
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 200, height: 50)
                    Text("\(buttonName)")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 180, height: 30, alignment: .center)
                }
    }
}

struct flowerSelectView: View{
    @EnvironmentObject var flowerManager: FlowerManager
//    let photos = [ "Iris", "Sunflower", "Jasmine", "Rose", "Tulip", "Hydrongea" ]
    var body: some View{
            GeometryReader { geometry in
                    ScrollViewReader { scrollView in
                        ZStack{
                            ScrollView(.horizontal) {
                                    HStack(alignment: .center) {
                                        ForEach(flowerManager.flower.indices, id: \.self) { index in
                                            VStack{
                                                Text(flowerManager.flower[index]).font(.largeTitle)
                                                ZStack{
                                                    NavigationLink(value: 5) {
                                                        Image(flowerManager.flower[index])
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .glow(color: Color.white, radius: 30)
                                                            .frame(width: geometry.size.width/2)
                                                            .padding(.horizontal, 50)
                                                            .id(index)
                                                    }
                                                    if index+1 == flowerManager.new{
                                                        Image("New")
                                                            .animation(Animation.spring(response: 0.1, dampingFraction: 0.8, blendDuration: 0.5))
                                                            .scaleEffect(1.2)
                                                            .position(x:geometry.size.width/5,y:geometry.size.height/4)
                                                    }
                                                }
                                                Text(Date(),style: .date).font(.title)
                                            }
                                        }
                                    }
                            }
//                            .disabled(true)
                            // Navigation Buttons
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        flowerManager.currentIndex = (flowerManager.currentIndex == 0) ? flowerManager.currentIndex : flowerManager.currentIndex - 1
                                        scrollView.scrollTo(flowerManager.currentIndex, anchor: .center)
                                    }
                                }) {
                                    Image("left")
                                        .scaledToFit()                                }
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        flowerManager.currentIndex = (flowerManager.currentIndex == flowerManager.flower.count - 1) ? flowerManager.currentIndex : flowerManager.currentIndex + 1
                                        scrollView.scrollTo(flowerManager.currentIndex, anchor: .center)
                                    }
                                }) {
                                    Image("right")
                                        .scaledToFit()
                                }
                                Spacer()
                            }
                        }
                        .frame(height: geometry.size.height)
                        .onAppear{
                            scrollView.scrollTo(flowerManager.new == -1 ?  flowerManager.currentIndex : flowerManager.new, anchor: .center)
                        }
                    }
                }
            .environmentObject(flowerManager)
    }
}

extension View {
    func glow(color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: radius)
//            .overlay(self.blur(radius: radius / 2))
    }
}
