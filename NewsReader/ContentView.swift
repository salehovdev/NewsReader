//
//  ContentView.swift
//  NewsReader
//
//  Created by Fuad Salehov on 12.05.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
        .tint(.black)
    }
}

#Preview {
    ContentView()
}
