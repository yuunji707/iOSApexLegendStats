//
//  PlayerStatsController.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import Foundation

class PlayerStatsController: ObservableObject {
    @Published var playerName: String = ""
    @Published var platform: String = "PC"
    @Published var stats: PlayerStats?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let apiService = ApexAPIService()
    
    func fetchPlayerStats() {
        guard !playerName.isEmpty else {
            errorMessage = "Please enter a player name"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                print("Fetching stats for player: \(playerName) on platform: \(platform)")
                let fetchedStats = try await apiService.fetchPlayerStats(playerName: playerName, platform: platform)
                DispatchQueue.main.async {
                    self.stats = fetchedStats
                    self.errorMessage = nil
                    self.isLoading = false
                    print("Received stats: \(fetchedStats)")
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                    self.stats = nil
                    print("Error fetching stats: \(error)")
                }
            }
        }
    }
}
