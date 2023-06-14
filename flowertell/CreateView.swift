//
//  CreateView.swift
//  flowertell
//
//  Created by 天责 on 2023/5/30.
//

import SwiftUI
import SpriteKit
import CoreMotion

class BottleScene: SKScene, SKPhysicsContactDelegate {
    @Binding var happyValue: CGFloat
    @Binding var calmValue: CGFloat
    @Binding var angryValue: CGFloat
    @Binding var sadValue: CGFloat
    @Binding var happyNodes: [SKShapeNode]
    @Binding var calmNodes: [SKShapeNode]
    @Binding var angryNodes: [SKShapeNode]
    @Binding var sadNodes: [SKShapeNode]

//    let bottleNode = SKSpriteNode(imageNamed: "bottle")
    let ballCategory: UInt32 = 0x1 << 0
    let groundCategory: UInt32 = 0x1 << 1
    let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let motionManager = CMMotionManager()

    init(happyValue: Binding<CGFloat>,calmValue: Binding<CGFloat>,angryValue: Binding<CGFloat>,sadValue: Binding<CGFloat>, happyNodes: Binding<[SKShapeNode]>,calmNodes: Binding<[SKShapeNode]>,angryNodes: Binding<[SKShapeNode]>,sadNodes: Binding<[SKShapeNode]>) {
        _happyValue = happyValue
        _calmValue = calmValue
        _angryValue = angryValue
        _sadValue = sadValue
        _happyNodes = happyNodes
        _calmNodes = calmNodes
        _angryNodes = angryNodes
        _sadNodes = sadNodes
        super.init(size: CGSize(width: 300, height: 300))
        self.backgroundColor = .clear
        
        let bottle = SKSpriteNode(imageNamed: "bottle")
        bottle.position = CGPoint(x: size.width/2, y: size.height/2.1)
        bottle.alpha = 0.7
        addChild(bottle)
        
        let bottlePath1 = UIBezierPath()
        bottlePath1.move(to: CGPoint(x: 0, y: 0))
        bottlePath1.addLine(to: CGPoint(x: -90, y: 0))
        bottlePath1.addLine(to: CGPoint(x: -32, y: 110))
        bottlePath1.addLine(to: CGPoint(x: -32, y: 210))
        bottlePath1.addLine(to: CGPoint(x: -90, y: 280))
        let bottlePath2 = UIBezierPath()
        bottlePath2.move(to: CGPoint(x: 0, y: 0))
        bottlePath2.addLine(to: CGPoint(x: 90, y: 0))
        bottlePath2.addLine(to: CGPoint(x: 32, y: 110))
        bottlePath2.addLine(to: CGPoint(x: 32, y: 210))
        bottlePath2.addLine(to: CGPoint(x: 90, y: 280))
        let bottleNode1 = SKShapeNode(path: bottlePath1.cgPath)
        let bottleNode2 = SKShapeNode(path: bottlePath2.cgPath)
        bottleNode1.strokeColor = SKColor.clear
        bottleNode1.lineWidth = 1.0
        bottleNode1.physicsBody = SKPhysicsBody(edgeChainFrom: bottlePath1.cgPath)
        bottleNode1.physicsBody?.isDynamic = false
        bottleNode1.position = CGPoint(x: size.width/2, y: 40)
        bottleNode2.strokeColor = SKColor.clear
        bottleNode2.lineWidth = 1.0
        bottleNode2.physicsBody = SKPhysicsBody(edgeChainFrom: bottlePath2.cgPath)
        bottleNode2.physicsBody?.isDynamic = false
        bottleNode2.position = CGPoint(x: size.width/2, y: 40)
        addChild(bottleNode1)
        addChild(bottleNode2)

        // 添加边缘碰撞体
        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: size))
        physicsBody?.categoryBitMask = groundCategory
        physicsBody?.contactTestBitMask = ballCategory
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self

        motionManager.startAccelerometerUpdates()
    }

    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
                    let acceleration = CGVector(dx: accelerometerData.acceleration.x * -50.0, dy: accelerometerData.acceleration.y * 50.0)
                    for ballNode in happyNodes + calmNodes + angryNodes + sadNodes {
                        ballNode.physicsBody?.applyForce(acceleration)
                    }
                }
        ballUpdate(ball: happyValue, node: &happyNodes, texture: "happyface")
        ballUpdate(ball: calmValue, node: &calmNodes, texture: "calmface")
        ballUpdate(ball: angryValue, node: &angryNodes, texture: "angryface")
        ballUpdate(ball: sadValue, node: &sadNodes, texture: "sadface")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == ballCategory || contact.bodyB.categoryBitMask == ballCategory {
            impactGenerator.impactOccurred()
        }
    }
    
    func ballUpdate(ball sliderValue: CGFloat, node ballNodes: inout [SKShapeNode], texture tex: String) {
        // 添加球体
        let ballnumber = Int(sliderValue/10)
        var index: CGFloat
        if ballnumber % 2 == 0 {
            index = 1
        }else{
            index = -1
        }
        if ballnumber > ballNodes.count {
            let ballNode = SKShapeNode(circleOfRadius: 13)
            let texture = SKTexture(imageNamed: tex)
            ballNode.fillTexture = texture
            ballNode.fillColor = .white
            ballNode.position = CGPoint(x: (size.width / 2)+(1 * index), y: (size.height*8/9)+(index * 20))
            ballNode.physicsBody = SKPhysicsBody(circleOfRadius: 12)
            ballNode.physicsBody?.categoryBitMask = ballCategory
            ballNode.physicsBody?.contactTestBitMask = ballCategory | groundCategory
            ballNode.physicsBody?.restitution = 0.5
            ballNode.physicsBody?.affectedByGravity = true
            addChild(ballNode)
            ballNodes.append(ballNode)
        }
        
        // 移除多余的球体节点
        while ballNodes.count > ballnumber {
            if let ballNode = ballNodes.last {
                ballNode.removeFromParent()
                ballNodes.removeLast()
            }
        }
    }
}

//主视图
struct CreateView: View {
    @EnvironmentObject var flowerManager: FlowerManager
    var ready = false
    @EnvironmentObject var chatgptModel: ViewModel
    @State var answer = "ask: nil"
    @State var response = "response: nil"
    //motion
    var motionManager = CMMotionManager()
    @State private var isShaking = false
    let startValve = 3.0
    //slider
    @State private var happyNodes: [SKShapeNode] = []
    @State private var calmNodes: [SKShapeNode] = []
    @State private var angryNodes: [SKShapeNode] = []
    @State private var sadNodes: [SKShapeNode] = []
    @State var happyIndex: CGFloat = 30
    @State var calmIndex: CGFloat = 40
    @State var angryIndex: CGFloat = 20
    @State var sadIndex: CGFloat = 10

    let csvString:String
    let example:String
    @State var ipt: String = ""
    @State var prompt:String = ""
    
    init(){
        let path = Bundle.main.path(forResource: "data", ofType: "csv")!
        let url = URL(fileURLWithPath: path)
        csvString = try! String(contentsOf: url, encoding: .utf8)
        
        example = """
                Input:
                Happiness/Joy: 30%
                Down/depressed: 100%
                Stress/irritability: 60%
                Calm/peaceful: 40%
                Output:
                "Flower":<Lily>
                "Reason":"Lily is a listener who calms your emotions"
                """
    }
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(){
                Image("Flower-Label").scaledToFit()
                Spacer()
                //gpting
//                Text(answer).foregroundColor(.white)
//                Text(response).foregroundColor(.white)
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.blue, lineWidth: 2)
//                    )
    //            Text("\(happyIndex)").foregroundColor(.white)
    //            if isShaking == false {
    //                Text("is not shaking").foregroundColor(.white)
    //            } else {
    //                Text("is shaked").foregroundColor(.red)
    //            }
//                Spacer()
                ZStack{
                    Circle().fill(LinearGradient(colors: [.clear, .white], startPoint: .leading, endPoint: .trailing))
                        .opacity(0.3)
                    SpriteView(scene: BottleScene(happyValue: $happyIndex, calmValue: $calmIndex, angryValue: $angryIndex, sadValue: $sadIndex, happyNodes: $happyNodes, calmNodes: $calmNodes, angryNodes: $angryNodes, sadNodes: $sadNodes), options:[.allowsTransparency])
                }
                .frame(width: geometry.size.width/1.5, height: geometry.size.width/1.5)
                Spacer()
                HStack(){
                    Image("happyface").scaledToFit()
                    SliderView3(value: $happyIndex, sliderRange: 0...100).frame(width:geometry.size.width * 3/4, height:geometry.size.height/25)
                }
                
                HStack(){
                    Image("calmface").scaledToFit()
                    SliderView3(value: $calmIndex, sliderRange: 0...100).frame(width:geometry.size.width * 3/4, height:geometry.size.height/25)
                }
                
                HStack(){
                    Image("angryface").scaledToFit()
                    SliderView3(value: $angryIndex, sliderRange: 0...100).frame(width:geometry.size.width * 3/4, height:geometry.size.height/25)
                }
                
                HStack(){
                    Image("sadface").scaledToFit()
                    SliderView3(value: $sadIndex, sliderRange: 0...100).frame(width:geometry.size.width * 3/4, height:geometry.size.height/25)
                }

                if response != "response: nil" {
                    NavigationLink(value: 2) {
                        createButton(buttonName: "开始")
                    }
                    .onAppear{
                        if let startIndex = response.range(of: "<")?.upperBound,
                           let endIndex = response.range(of: ">")?.lowerBound,
                           startIndex < endIndex {
                            let extractedText = response[startIndex..<endIndex]
                            flowerManager.newName = String(extractedText)
                        }
                    }
                } else {
                    Image("shake").scaledToFit()
                }
                
//                Button {
//                    ipt = """
//                            Happiness/Joy: \(happyIndex)%
//                            Down/depressed: \(sadIndex)%
//                            Stress/irritability: \(angryIndex)%
//                            Calm/peaceful: \(calmIndex)%
//                            """
//
//                    prompt = """
//                            You are a florist who is good at using flowers to express emotions.
//                            Your task is to recommend the most suitable flower from the given options based on the emotional ratio I entered and give a simple reason.
//                            There are a total of seven kinds of flowers in the options, and each has its own basic information, personality settings and background stories. Please refer to these information for recommendations.
//                            The information of the seven flowers is as follows:
//                            <flowers>
//                            \(csvString)
//                            </flowers>
//                            The mood scale is controlled by sliders in four dimensions, including happy/joyful, low/depressed, stress/irritable, calm/peaceful.
//                            Here is an example:
//                            <example>
//                            \(example)
//                            </example>
//                            The current input is:
//                            <input>
//                            \(ipt)
//                            </input>
//                            Please suggest suitable flowers for me following the JSON format like the given example
//                            """
//                    answer = prompt
//                    send()
//                } label: {
//                    Text("下一步").foregroundColor(.white)
//                }.buttonStyle(BorderButtonStyle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("Background").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea())
            
            .onAppear {
                        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                            guard let data = data else { return }
                            let acc = data.acceleration
                            let accValue = sqrt(pow(acc.x, 2) + pow(acc.y, 2) + pow(acc.z, 2))
                            if accValue > startValve && !isShaking{
                                ipt = """
                                        Happiness/Joy: \(happyIndex)%
                                        Down/depressed: \(sadIndex)%
                                        Stress/irritability: \(angryIndex)%
                                        Calm/peaceful: \(calmIndex)%
                                        """
    
                                prompt = """
                                        You are a florist who is good at using flowers to express emotions.
                                        Your task is to recommend the most suitable flower from the given options based on the emotional ratio I entered and give a simple reason.
                                        There are a total of seven kinds of flowers in the options, and each has its own basic information, personality settings and background stories. Please refer to these information for recommendations.
                                        The information of the seven flowers is as follows:
                                        <flowers>
                                        \(csvString)
                                        </flowers>
                                        The mood scale is controlled by sliders in four dimensions, including happy/joyful, low/depressed, stress/irritable, calm/peaceful.
                                        Here is an example:
                                        <example>
                                        \(example)
                                        </example>
                                        The current input is:
                                        <input>
                                        \(ipt)
                                        </input>
                                        Please suggest suitable flowers for me following the JSON format like the given example
                                        """
                                answer = prompt
                                send()
                                isShaking.toggle()
                            }
                        }
                    }
            .onDisappear {
                        motionManager.stopAccelerometerUpdates()
                        isShaking = false
                    }
        }
    }
    func send() {
        guard !answer.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        chatgptModel.send(text: answer){
            response in DispatchQueue.main.async {
                self.response = response
                self.answer = "ask:"
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}

//自定义了一个slider bar的格式
struct SliderView3: View {
    @Binding var value: CGFloat
    
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 1...100
    var thumbColor: Color = .yellow
    var minTrackColor: Color = .white
    var maxTrackColor: Color = .gray
    
    var body: some View {
        GeometryReader { gr in
            let thumbHeight = gr.size.height
            let thumbWidth = gr.size.height
            let radius = gr.size.height * 0.5
            let minValue = gr.size.width * 0.005
            let maxValue = gr.size.width - thumbWidth
            
            let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
            let lower = sliderRange.lowerBound
            let sliderVal = (self.value - lower) * scaleFactor + minValue
            
            ZStack {
                Rectangle()
                    .foregroundColor(maxTrackColor)
                    .frame(width: gr.size.width, height: gr.size.height)
                    .clipShape(RoundedRectangle(cornerRadius: radius))
                HStack {
                    Rectangle()
                        .foregroundColor(minTrackColor)
                        .frame(width: sliderVal+gr.size.height*0.45, height: gr.size.height )
                    Spacer()
                }
                .clipShape(RoundedRectangle(cornerRadius: radius))
                HStack {
                    RoundedRectangle(cornerRadius: radius)
                        .foregroundColor(.white)
                        .frame(width: thumbWidth, height: thumbHeight)
                        .offset(x: sliderVal)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { v in
                                    if (abs(v.translation.width) < 0.1) {
                                        self.lastCoordinateValue = sliderVal
                                    }
                                    if v.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                               }
                        )
                    Spacer()
                }
            }
        }
    }
}

