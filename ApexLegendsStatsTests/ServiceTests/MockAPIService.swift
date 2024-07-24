//
//  MockAPIService.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//


import Foundation
import RxSwift
@testable import ApexLegendsStats

class MockApexAPIService: ApexAPIService {
    var mockMapRotationResponse: Observable<MapRotationResponse>?
    var mockPlayerStats: PlayerStats?
    var mockNews: [NewsItem]?
    var mockServerStatus: ServerStatus?
    
    var fetchMapRotationCalled = false
    var fetchPlayerStatsCalled = false
    var fetchNewsCalled = false
    var fetchServerStatusCalled = false

    override func fetchMapRotation() -> Observable<MapRotationResponse> {
        fetchMapRotationCalled = true
        return mockMapRotationResponse ?? super.fetchMapRotation()
    }

    override func fetchPlayerStats(playerName: String, platform: String) async throws -> PlayerStats {
        fetchPlayerStatsCalled = true
        if let mockStats = mockPlayerStats {
            return mockStats
        }
        return try await super.fetchPlayerStats(playerName: playerName, platform: platform)
    }

    override func fetchNews() async throws -> [NewsItem] {
        fetchNewsCalled = true
        if let mockNews = mockNews {
            return mockNews
        }
        throw NSError(domain: "MockApexAPIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock news data is nil"])
    }

    override func fetchServerStatus() async throws -> ServerStatus {
        fetchServerStatusCalled = true
        if let mockStatus = mockServerStatus {
            return mockStatus
        }
        throw NSError(domain: "MockApexAPIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock server status is nil"])
    }
    
}
