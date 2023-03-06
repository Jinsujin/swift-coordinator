//
//  ContentView.swift
//  SwiftUI-Vanilla
//
//  Created by Sujin Jin on 2023/03/06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabHomeView()
    }
}

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

struct ColorDetail: View {
    var color: Color

    var body: some View {
        color.navigationTitle(color.description)
    }
}

struct CoordinateWithListView: View {
    let colors: [Color] = [.mint, .pink, .teal]
    @State private var selection: Color?
    
    var body: some View {
        NavigationSplitView {
            List(colors, id: \.self, selection: $selection) { color in
                NavigationLink(color.description, value: color)
            }
        } detail: {
            if let color = selection {
                ColorDetail(color: color)
            } else {
                Text("Pick a color")
            }
        }
    }
}

struct AContent: View {

    var body: some View {
        // 사람들은 navigation link 를 탭해서 NavigationStack 또는 NavigationSplitView 에 View 를 표시한다.
        
        // 1. Label 을 사용하여 link 를 표시
//        NavigationLink { // Destination
//            ADetail()
//        } label: {
//            Label("Work Folder", systemImage: "folder")
//        }
        
        // 2. String 을 사용한 convenience initializer
//        NavigationLink("Work Folder") {
//            ADetail()
//        }
        
        // 3.
        NavigationStack {
            List {
                NavigationLink("Mint", value: Color.mint)
                NavigationLink("Pink", value: Color.pink)
                NavigationLink("Teal", value: Color.teal)
            }
            .navigationDestination(for: Color.self) { color in
                ColorDetail(color: color)
            }
            .navigationTitle("Colors")
        }
    }
}

struct TabHomeView: View {
    @State private var currentTab: Tab = .one
    
    var body: some View {
        TabView(selection: $currentTab) {
            AContent()
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
