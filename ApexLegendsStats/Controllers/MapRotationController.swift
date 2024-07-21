//
//  MapRotationController.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import Foundation

class MapRotationController: ObservableObject {
    @Published var battleRoyale: MapRotation?
    @Published var ranked: MapRotation?
    @Published var mixtape: MapRotation?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let apiService = ApexAPIService()
    
    func fetchMapRotation() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await apiService.fetchMapRotation()
                DispatchQueue.main.async {
                    self.battleRoyale = response.battleRoyale
                    self.ranked = response.ranked
                    self.mixtape = response.ltm
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}
