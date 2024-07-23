//
//  PlayerStatsController.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import Foundation

/// Controller class for managing player statistics in Apex Legends
class PlayerStatsController: ObservableObject {
    // Published properties for player information and stats
    @Published var playerName: String = ""
    @Published var platform: String = "PC"
    @Published var stats: PlayerStats?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let apiService = ApexAPIService()
    
    /// Fetches player statistics from the API
    func fetchPlayerStats() {
        guard !playerName.isEmpty else {
            errorMessage = "Please enter a player name"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedStats = try await apiService.fetchPlayerStats(playerName: playerName, platform: platform)
                DispatchQueue.main.async {
                    self.stats = fetchedStats
                    self.errorMessage = nil
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                    self.stats = nil
                }
            }
        }
    }
}
