//
//  ServerStatusController.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import SwiftUI

class ServerStatusController: ObservableObject {
    @Published var serverStatus: ServerStatus?
    @Published var selectedServerType: ServerType = .origin
    @Published var currentRegionStatus: [RegionStatusData] = []
    
    private let apiService = ApexAPIService()
    
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

struct RegionStatusData: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let responseTime: Int
}

enum ServerType {
    case origin, eaNova, eaAccounts, crossplay
}
