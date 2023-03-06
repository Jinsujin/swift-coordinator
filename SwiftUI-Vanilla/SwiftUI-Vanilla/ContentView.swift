//
//  ContentView.swift
//  SwiftUI-Vanilla
//
//  Created by Sujin Jin on 2023/03/06.
//

import SwiftUI

enum Tab {
    case one
    case two
    case three
}

struct ADetail: View {
    var body: some View {
        Text("A")
    }
}

struct ContentView: View {
    var body: some View {
        TabHomeView()
    }
}

struct TabHomeView: View {
    @State private var currentTab: Tab = .one
    
    var body: some View {
        TabView(selection: $currentTab) {
            BasicNavigationView()
                .tabItem{ Text("One") }
                .tag(Tab.one)
            
            Text("Two")
                .tabItem{ Text("Two") }
                .tag(Tab.two)
            
            Text("Three")
                .tabItem{ Text("Three") }
                .tag(Tab.three)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
