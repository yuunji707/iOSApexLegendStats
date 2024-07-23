//
//  ServerStatusController.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import SwiftUI

/// Controller class for managing Apex Legends server status
class ServerStatusController: ObservableObject {
    @Published var serverStatus: ServerStatus?
    @Published var selectedServerType: ServerType = .origin
    @Published var currentRegionStatus: [RegionStatusData] = []
    
    private let apiService = ApexAPIService()
    
    /// Fetches the current server status from the API
    func fetchServerStatus() {
        Task {
            do {
                let status = try await apiService.fetchServerStatus()
                DispatchQueue.main.async {
                    self.serverStatus = status
                    self.updateCurrentRegionStatus()
                }
            } catch {
                print("Error fetching server status: \(error)")
            }
        }
    }
    
    /// Updates the current region status based on the selected server type
    func updateCurrentRegionStatus() {
        guard let serverStatus = serverStatus else { return }
        
        let regionStatus: RegionStatus
        switch selectedServerType {
        case .origin:
            regionStatus = serverStatus.originLogin
        case .eaNova:
            regionStatus = serverStatus.eaNovafusion
        case .eaAccounts:
            regionStatus = serverStatus.eaAccounts
        case .crossplay:
            regionStatus = serverStatus.apexOauthCrossplay
        }
        
        // Create an array of RegionStatusData for each region
        currentRegionStatus = [
            RegionStatusData(name: "EU West", status: regionStatus.euWest.status, responseTime: regionStatus.euWest.responseTime),
            RegionStatusData(name: "EU East", status: regionStatus.euEast.status, responseTime: regionStatus.euEast.responseTime),
            RegionStatusData(name: "US West", status: regionStatus.usWest.status, responseTime: regionStatus.usWest.responseTime),
            RegionStatusData(name: "US Central", status: regionStatus.usCentral.status, responseTime: regionStatus.usCentral.responseTime),
            RegionStatusData(name: "US East", status: regionStatus.usEast.status, responseTime: regionStatus.usEast.responseTime),
            RegionStatusData(name: "South America", status: regionStatus.southAmerica.status, responseTime: regionStatus.southAmerica.responseTime),
            RegionStatusData(name: "Asia", status: regionStatus.asia.status, responseTime: regionStatus.asia.responseTime)
        ]
    }
}

/// Struct to hold region status data for display purposes
struct RegionStatusData: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let responseTime: Int
}

/// Enum representing different server types
enum ServerType {
    case origin, eaNova, eaAccounts, crossplay
}
