//
//  MessageView.swift
//  flowertell
//
//  Created by 天责 on 2023/6/6.
//

import SwiftUI

struct MessageView: View {
    @State private var liked = false
    var index: Int = 0
    @State private var message: String = ""
    var body: some View {
        ZStack{
            GeometryReader{ geometry in
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.black.opacity(0.2))
                        .scaledToFit()
                    VStack{
                        Text("page: \(index)").font(.title)
                        Text("最近状态好奇怪，明明什么都没做就感到很累了")
                        HStack{
                            Image("level1")
                                .resizable()
                                .clipShape(Rectangle())
                                .frame(width: geometry.size.width/2.2, height: geometry.size.width/2.2)
                            Image("level2")
                                .resizable()
                                .clipShape(Rectangle())
                                .frame(width: geometry.size.width/2.2, height: geometry.size.width/2.2)
                        }
                        .padding(.horizontal)
                        Image(systemName: "heart.fill")
                            .foregroundColor(liked ? .red : .gray)
                            .onTapGesture {
                                self.liked.toggle()}
                            .padding()
                        TextField("赠人玫瑰手有余香，鼓励一下TA吧！", text: $message)
                            .tint(.gray)
                            .background(Color.clear)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
        }

    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
