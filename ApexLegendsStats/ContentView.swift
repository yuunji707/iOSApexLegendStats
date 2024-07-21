//
//  ContentView.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import SwiftUI

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
        }
    }
}
