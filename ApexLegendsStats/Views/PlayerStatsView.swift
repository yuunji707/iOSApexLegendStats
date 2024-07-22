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
            
            TextField("Enter player name", text: $controller.playerName)
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
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        PlayerLevelView(level: stats.global.level, toNextLevelPercent: stats.global.toNextLevelPercent)
                        
                        PlayerRankView(rank: stats.global.rank)
                        
                        SelectedLegendView(selectedLegend: stats.legends.selected)
                    }
                    .padding()
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

struct PlayerLevelView: View {
    let level: Int
    let toNextLevelPercent: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Level: \(level)")
                .font(.headline)
            ProgressView(value: Float(toNextLevelPercent), total: 100)
            Text("Progress to next level: \(toNextLevelPercent)%")
        }
    }
}

struct PlayerRankView: View {
    let rank: Rank
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Rank: \(rank.rankName) \(rank.rankDiv)")
                .font(.headline)
            AsyncImage(url: URL(string: rank.rankImg)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
        }
    }
}

struct SelectedLegendView: View {
    let selectedLegend: SelectedLegend
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Selected Legend: \(selectedLegend.LegendName)")
                .font(.headline)
            AsyncImage(url: URL(string: selectedLegend.ImgAssets.icon)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            ForEach(selectedLegend.data, id: \.name) { data in
                Text("\(data.name): \(data.value)")
            }
        }
    }
}
