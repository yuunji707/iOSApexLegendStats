//
//  PlayerStatsView.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import SwiftUI

struct PlayerStatsView: View {
    @StateObject private var controller = PlayerStatsController()
    
    var body: some View {
        VStack {
            Text("Player Statistics")
                .font(.title)
                .padding()
            
            TextField("Enter player name", text: Binding(
                get: { self.controller.playerName },
                set: { self.controller.playerName = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Picker("Platform", selection: $controller.platform) {
                Text("PC").tag("PC")
                Text("PS4").tag("PS4")
                Text("Xbox").tag("X1")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Fetch Stats") {
                controller.fetchPlayerStats()
            }
            .padding()
            .disabled(controller.isLoading)
            
            if controller.isLoading {
                ProgressView()
            } else if let stats = controller.stats {
                VStack(alignment: .leading) {
                    Text("Name: \(stats.name)")
                    Text("Level: \(stats.level)")
                    Text("Kills: \(stats.kills)")
                    // Add more stats as needed
                }
            }
            
            if let errorMessage = controller.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}
