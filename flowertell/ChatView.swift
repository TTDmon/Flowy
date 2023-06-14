//
//  chatView.swift
//  flowertell
//
//  Created by 天责 on 2023/6/6.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        HStack{
            Image("comment").resizable().scaledToFit()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Image("Background2").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea())
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
