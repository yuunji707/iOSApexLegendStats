//
//  ContentView.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import SwiftUI

/// The main view of the app, containing a tab bar for navigation between different features
struct ContentView: View {
    var body: some View {
        TabView {
            MapRotationView()
                .tabItem {
                    Label("Map Rotation", systemImage: "map")
                }
            
            PlayerStatsView()
                .tabItem {
                    Label("Player Stats", systemImage: "person")
                }
            
            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            ServerStatusView()
                .tabItem {
                    Label("Server Status", systemImage: "network")
                }
        }
    }
}
