//import SwiftUI
//import SpriteKit
//
//struct test: View {
//    @State private var sliderValue: CGFloat = 0
//    @State private var ballNodes: [SKShapeNode] = []
//
//    var body: some View {
//        VStack {
//            SpriteView(scene: BottleScene(sliderValue: $sliderValue, ballNodes: $ballNodes)).frame(width: 300, height: 300)
//            Slider(value: $sliderValue, in: 1...100)
//        }
//    }
//}
//
//class BottleScene: SKScene, SKPhysicsContactDelegate {
//    @Binding var sliderValue: CGFloat
//    @Binding var ballNodes: [SKShapeNode]
//
////    let bottleNode = SKSpriteNode(imageNamed: "bottle")
//    let ballCategory: UInt32 = 0x1 << 0
//    let groundCategory: UInt32 = 0x1 << 1
//
//    init(sliderValue: Binding<CGFloat>, ballNodes: Binding<[SKShapeNode]>) {
//        _sliderValue = sliderValue
//        _ballNodes = ballNodes
//        super.init(size: CGSize(width: 300, height: 300))
//        backgroundColor = .gray
//
////        // 添加烧瓶容器
////        bottleNode.position = CGPoint(x: size.width / 2, y: 150)
////        addChild(bottleNode)
//
////        // 添加滑块
////        let sliderNode = SKSpriteNode(imageNamed: "slider")
////        sliderNode.position = CGPoint(x: size.width / 2, y: 50)
////        addChild(sliderNode)
//
//        // 添加底部碰撞体
//        let groundNode = SKShapeNode(rectOf: CGSize(width: size.width*0.8, height: 10))
//        groundNode.fillColor = .black
//        groundNode.strokeColor = .black
//        groundNode.position = CGPoint(x: size.width/2, y: 10)
//        groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width*0.8, height: 10))
//        groundNode.physicsBody?.categoryBitMask = groundCategory
//        groundNode.physicsBody?.contactTestBitMask = ballCategory
//        groundNode.physicsBody?.affectedByGravity = false
//        addChild(groundNode)
//
//        // 添加边缘碰撞体
//        physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: size))
//        physicsBody?.categoryBitMask = groundCategory
//        physicsBody?.contactTestBitMask = ballCategory
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func didMove(to view: SKView) {
//        physicsWorld.contactDelegate = self
//    }
//
//    override func update(_ currentTime: TimeInterval) {
//        // 添加球体
//        let ballnumber = Int(sliderValue/5)
//        let labelNode = SKLabelNode(text: "\(ballnumber)")
//        let labelNode2 = SKLabelNode(text: "\(ballNodes.count)")
//        labelNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        labelNode2.position = CGPoint(x: size.width / 2, y: size.height / 4)
//        labelNode.color = .black
//        addChild(labelNode)
//        addChild(labelNode2)
//        if ballnumber > ballNodes.count {
//            let ballNode = SKShapeNode(circleOfRadius: 10)
//            ballNode.fillColor = .red
//            ballNode.position = CGPoint(x: (size.width / 2)+CGFloat(ballNodes.count + 1), y: size.height-CGFloat(ballNodes.count + 1))
//            ballNode.physicsBody = SKPhysicsBody(circleOfRadius: 10)
//            ballNode.physicsBody?.categoryBitMask = ballCategory
//            ballNode.physicsBody?.contactTestBitMask = ballCategory | groundCategory
//            ballNode.physicsBody?.restitution = 0.7
//            ballNode.physicsBody?.affectedByGravity = true
//            addChild(ballNode)
//            ballNodes.append(ballNode)
//        }
//
//        // 移除多余的球体节点
//        while ballNodes.count > ballnumber {
//            if let ballNode = ballNodes.last {
//                ballNode.removeFromParent()
//                ballNodes.removeLast()
//            }
//        }
//
//    }
//}
//
////extension BottleScene: SKPhysicsContactDelegate {
////    func didBegin(_ contact: SKPhysicsContact) {
////        // 移除掉落到底部的球体
////        if contact.bodyA.categoryBitMask == groundCategory && contact.bodyB.categoryBitMask == ballCategory {
////            if let ballNode = contact.bodyB.node as? SKShapeNode, let index = ballNodes.firstIndex(of: ballNode) {
////                ballNodes.remove(at: index)
////                ballNode.removeFromParent()
////            }
////        }
////    }
////}
//
//struct test_Previews: PreviewProvider {
//    static var previews: some View {
//        test()
//    }
//}
