//
//  ContentView.swift
//  Flick
//
//  Created by 豆子 on 2025/1/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                OverviewView()
            }
            .tabItem {
                Label("总览", systemImage: "house.fill")
            }
            
            NavigationView {
                ProjectView()
            }
            .tabItem {
                Label("项目", systemImage: "list.bullet")
            }
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("设置", systemImage: "gearshape.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
