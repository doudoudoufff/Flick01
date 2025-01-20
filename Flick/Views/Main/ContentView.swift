//
//  ContentView.swift
//  Flick
//
//  Created by 豆子 on 2025/1/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TabView {
                OverviewView()
                    .tabItem {
                        Label("总览", systemImage: "house.fill")
                    }
                
                ProjectView()
                    .tabItem {
                        Label("项目", systemImage: "list.bullet")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("设置", systemImage: "gearshape.fill")
                    }
            }
        }
        .navigationViewStyle(.stack)
        .gesture(DragGesture().onEnded { gesture in
            if gesture.translation.width > 100 {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), 
                                             to: nil, 
                                             from: nil, 
                                             for: nil)
                
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                let rootViewController = window?.rootViewController
                rootViewController?.navigationController?.popViewController(animated: true)
            }
        })
    }
}

#Preview {
    ContentView()
}
