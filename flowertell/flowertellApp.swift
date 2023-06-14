//
//  flowertellApp.swift
//  flowertell
//
//  Created by 天责 on 2023/5/24.
//

import SwiftUI

enum Views {
    case view1
    case view2
}

class ViewRouter: ObservableObject {
    @Published var currentView: Views = .view1
}

struct MainView: View {
    @ObservedObject var viewRouter = ViewRouter()
    var body: some View {
        switch viewRouter.currentView {
        case .view1:
            StartView().environmentObject(viewRouter)
        case .view2:
            ContentView().environmentObject(viewRouter)
                }
    }
}

@main
struct flowertellApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
//            gptView()
        }
    }
}

struct MainPreviews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

