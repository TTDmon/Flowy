//
//  ListeningView.swift
//  flowertell
//
//  Created by 天责 on 2023/6/1.
//

import SwiftUI

struct ListeningView: View {
    @EnvironmentObject var chatgptModel: ViewModel
    @State private var isBlinking = false
    @EnvironmentObject var flowerManager: FlowerManager
    @EnvironmentObject var pathManager:PathManager
    @State private var message = ""
    @State private var answer = ""
    @State private var response = "nil"

    var body: some View {
        GeometryReader{ proxy in
                VStack{
                    Image("Listening-Label")
                    Spacer()
                    Image(flowerManager.newName)
                        .glow(color: .white, radius: isBlinking ? 5 : 20)
                        .scaledToFit()
                        .onAppear {
                            // 创建一个无限循环的计时器
                            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    self.isBlinking.toggle()
                                }
                            }
                        }
                    Spacer()
                    if response != "nil" {
                        Text("\"\(response)\"").foregroundColor(.white).font(.title).multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }else{
                        Text("送君\(flowerManager.newName)，愿君莫离\n\"对我而言，你尽可放肆哭泣\"").font(.title).multilineTextAlignment(.center)
                    }
                    
                    ZStack() {
                        if message.isEmpty {
                            Text("写下你的心情\n\(flowerManager.newName)会倾听\n......")
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .opacity(0.7)
                                .foregroundColor(.white)
                                .padding(5)
                        }
                        HStack{
                            Image("{")
                            CustomTextEditor(text: $message)
                                .frame(width: proxy.size.width/2, height: proxy.size.height/10)
                                .multilineTextAlignment(.center)
                                .background(Color.clear)
                            Image("}")
                        }
                    }
                    Spacer()
                    Text("故事就从这里开始吧！").tint(.gray)
                    HStack{
                        Button {
                            var examples = """
                                diary:"I'm in a strange state recently, I'm still very tired even though I haven't done anything every day, am I depressed?"
                                response:"Don't worry, everyone has a similar state. Haizi once wrote "I don't want to do anything, just lie on the bed and look at the sky outside the window." If you feel tired, take a good rest, this state is not terrible."

                                diary:"Grandma passed away the day before yesterday, and she was too sad to eat. I know that life is impermanent, but I didn't expect that death would be so powerless when I really faced it."
                                response:"Well, I understand your difficulties. I regret the death of your grandmother. Tagore wrote in "Life Like Summer Flowers", "Life is as gorgeous as summer flowers, and death is as quiet and beautiful as autumn leaves." Accept the laws and changes of nature, without leaving regrets and resentments, and don't need to be overly sad about it."
                                """
                            let prompt = """
                            you are a psychotherapist.
                            You will assume the role of a flower and comment on the user's diary in order to achieve a healing effect.
                            The flower you need to personate is:{\(flowerManager.newName)}
                            Please strictly follow the role of the flower to personate, you can also refer to the background story and basic information provided.
                            Here are some examples:
                            <example>
                            \(examples)
                            </example>
                            The user's diary:
                            <diary>
                            \(message)
                            </diary>
                            Please output your results in poetry format and limit to 50 words.
                            """
                            answer = prompt
                            send()
                        } label: {
                            Text("公开发布").frame(width: 150)
                        }.buttonStyle(BorderButtonStyle())
                        
                        Button {
                            let index = flowerManager.flower.count/2
                            flowerManager.flower.insert(flowerManager.newName, at: index)
                            withAnimation {
                                flowerManager.new = index + 1
                                pathManager.path.removeLast(pathManager.path.count)
                            }
                        } label: {
                            Text("完成").frame(width: 150)
                        }.buttonStyle(BorderButtonStyle())
                    }
                    

                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Image("Background2").ignoresSafeArea().scaledToFill())
                .background(Image("Background2").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea())
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

struct ListeningView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear // 设置为透明
        textView.textAlignment = .center // 设置文本居中
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        textView.tintColor = .white
        textView.textColor = .white
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
    }
}
