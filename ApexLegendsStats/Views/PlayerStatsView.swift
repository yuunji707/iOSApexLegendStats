//
//  PlayerStatsView.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import SwiftUI

/// A view that displays player statistics for Apex Legends
struct PlayerStatsView: View {
    @StateObject private var controller = PlayerStatsController()
    @State private var isSearchExpanded = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                searchSection
                
                if controller.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else if let stats = controller.stats {
                    statsContent(stats)
                }
                
                if let errorMessage = controller.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Player Statistics")
        }
    }
    
    // MARK: - Subviews
    
    /// Search section including player name input and platform selection
    private var searchSection: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Enter player name", text: $controller.playerName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                
                // Clear button appears when text is not empty
                if !controller.playerName.isEmpty {
                    Button(action: {
                        controller.playerName = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            platformButtons
            
            Button(action: {
                controller.fetchPlayerStats()
            }) {
                Text("Fetch Stats")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(controller.playerName.isEmpty || controller.isLoading)
        }
    }
    
    /// Buttons for selecting the player's platform
    private var platformButtons: some View {
        HStack(spacing: 10) {
            platformButton(title: "PC", platform: "PC")
            platformButton(title: "PS4/PS5", platform: "PS4")
            platformButton(title: "Xbox", platform: "X1")
        }
    }
    
    /// Creates a button for a specific platform
    private func platformButton(title: String, platform: String) -> some View {
        Button(action: {
            controller.platform = platform
        }) {
            Text(title)
                .foregroundColor(controller.platform == platform ? .white : .blue)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(controller.platform == platform ? Color.blue : Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
    }
    
    /// Displays the player's statistics
    private func statsContent(_ stats: PlayerStats) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PlayerLevelView(level: stats.global.level, toNextLevelPercent: stats.global.toNextLevelPercent)
                
                PlayerRankView(rank: stats.global.rank)
                
                SelectedLegendView(selectedLegend: stats.legends.selected)
            }
            .padding()
        }
    }
}

// MARK: - Subviews

/// Displays the player's current level and progress to the next level
struct PlayerLevelView: View {
    let level: Int
    let toNextLevelPercent: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Level: \(level)")
                .font(.headline)
            ProgressView(value: Float(toNextLevelPercent), total: 100)
                .accentColor(.green)
            Text("Progress to next level: \(toNextLevelPercent)%")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

/// Displays the player's current rank
struct PlayerRankView: View {
    let rank: Rank
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: rank.rankImg)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            
            VStack(alignment: .leading) {
                Text("Rank")
                    .font(.headline)
                Text("\(rank.rankName) \(rank.rankDiv)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

/// Displays information about the player's selected legend
struct SelectedLegendView: View {
    let selectedLegend: SelectedLegend
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AsyncImage(url: URL(string: selectedLegend.ImgAssets.icon)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                
                VStack(alignment: .leading) {
                    Text("Selected Legend")
                        .font(.headline)
                    Text(selectedLegend.LegendName)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            
            ForEach(selectedLegend.data, id: \.name) { data in
                HStack {
                    Text(data.name)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(data.value)")
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
