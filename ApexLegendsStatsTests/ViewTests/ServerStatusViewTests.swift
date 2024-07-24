//
//  ServerStatusViewTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//
import XCTest
@testable import ApexLegendsStats

class ServerStatusTests: XCTestCase {
    
    var mockAPIService: MockApexAPIService!
    var mockController: MockServerStatusController!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockApexAPIService()
        mockController = MockServerStatusController(mockAPIService: mockAPIService)
    }
    
    override func tearDown() {
        mockAPIService = nil
        mockController = nil
        super.tearDown()
    }
    
    func testFetchServerStatus() {
        // Given
        let mockStatus = createMockServerStatus()
        mockAPIService.mockServerStatus = mockStatus
        
        // When
        mockController.fetchServerStatus()
        
        // Then
        XCTAssertTrue(mockController.fetchServerStatusCalled)
        XCTAssertTrue(self.compareServerStatus(mockController.serverStatus, mockStatus))
        XCTAssertTrue(mockController.updateCurrentRegionStatusCalled)
    }
    
    func testUpdateCurrentRegionStatus() {
        // Given
        mockController.serverStatus = createMockServerStatus()
        
        // When
        mockController.selectedServerType = .origin
        mockController.updateCurrentRegionStatus()
        
        // Then
        XCTAssertTrue(mockController.updateCurrentRegionStatusCalled)
        XCTAssertEqual(mockController.currentRegionStatus.count, 7)
        XCTAssertEqual(mockController.currentRegionStatus[0].name, "EU West")
        XCTAssertEqual(mockController.currentRegionStatus[0].status, "UP")
        XCTAssertEqual(mockController.currentRegionStatus[0].responseTime, 100)
    }
    
    func testUpdateCurrentRegionStatusWithDifferentServerTypes() {
        // Given
        mockController.serverStatus = createMockServerStatus()
        
        // Test for each server type
        let serverTypes: [ServerType] = [.origin, .eaNova, .eaAccounts, .crossplay]
        
        for serverType in serverTypes {
            // When
            mockController.selectedServerType = serverType
            mockController.updateCurrentRegionStatus()
            
            // Then
            XCTAssertTrue(mockController.updateCurrentRegionStatusCalled)
            XCTAssertEqual(mockController.currentRegionStatus.count, 7, "Region count should be 7 for \(serverType)")
            XCTAssertEqual(mockController.currentRegionStatus[0].name, "EU West", "First region should be EU West for \(serverType)")
            
            // Check if the status and response time are updated correctly
            switch serverType {
            case .origin:
                XCTAssertEqual(mockController.currentRegionStatus[0].status, "UP", "Status should be UP for Origin")
                XCTAssertEqual(mockController.currentRegionStatus[0].responseTime, 100, "Response time should be 100 for Origin")
            case .eaNova:
                XCTAssertEqual(mockController.currentRegionStatus[0].status, "DOWN", "Status should be DOWN for EA Nova")
                XCTAssertEqual(mockController.currentRegionStatus[0].responseTime, 200, "Response time should be 200 for EA Nova")
            case .eaAccounts:
                XCTAssertEqual(mockController.currentRegionStatus[0].status, "UP", "Status should be UP for EA Accounts")
                XCTAssertEqual(mockController.currentRegionStatus[0].responseTime, 150, "Response time should be 150 for EA Accounts")
            case .crossplay:
                XCTAssertEqual(mockController.currentRegionStatus[0].status, "UP", "Status should be UP for Crossplay")
                XCTAssertEqual(mockController.currentRegionStatus[0].responseTime, 120, "Response time should be 120 for Crossplay")
            }
        }
    }
    
    func testInitialState() {
        XCTAssertNil(mockController.serverStatus)
        XCTAssertEqual(mockController.selectedServerType, .origin)
        XCTAssertTrue(mockController.currentRegionStatus.isEmpty)
    }
    
    // Helper method to create a mock ServerStatus
    private func createMockServerStatus() -> ServerStatus {
        let mockTimestamp = 1690214400 // July 24, 2024, 00:00:00 UTC
        let mockRegion = ServerRegion(status: "UP", httpCode: 200, responseTime: 100, queryTimestamp: mockTimestamp)
        let mockRegionStatus = RegionStatus(
            euWest: mockRegion,
            euEast: mockRegion,
            usWest: mockRegion,
            usCentral: mockRegion,
            usEast: mockRegion,
            southAmerica: mockRegion,
            asia: mockRegion
        )
        
        return ServerStatus(
            originLogin: mockRegionStatus,
            eaNovafusion: RegionStatus(
                euWest: ServerRegion(status: "DOWN", httpCode: 500, responseTime: 200, queryTimestamp: mockTimestamp),
                euEast: mockRegion,
                usWest: mockRegion,
                usCentral: mockRegion,
                usEast: mockRegion,
                southAmerica: mockRegion,
                asia: mockRegion
            ),
            eaAccounts: RegionStatus(
                euWest: ServerRegion(status: "UP", httpCode: 200, responseTime: 150, queryTimestamp: mockTimestamp),
                euEast: mockRegion,
                usWest: mockRegion,
                usCentral: mockRegion,
                usEast: mockRegion,
                southAmerica: mockRegion,
                asia: mockRegion
            ),
            apexOauthCrossplay: RegionStatus(
                euWest: ServerRegion(status: "UP", httpCode: 200, responseTime: 120, queryTimestamp: mockTimestamp),
                euEast: mockRegion,
                usWest: mockRegion,
                usCentral: mockRegion,
                usEast: mockRegion,
                southAmerica: mockRegion,
                asia: mockRegion
            )
        )
    }
    
    // Custom comparison function for ServerStatus
    private func compareServerStatus(_ lhs: ServerStatus?, _ rhs: ServerStatus?) -> Bool {
        guard let lhs = lhs, let rhs = rhs else {
            return lhs == nil && rhs == nil
        }
        
        return compareRegionStatus(lhs.originLogin, rhs.originLogin) &&
               compareRegionStatus(lhs.eaNovafusion, rhs.eaNovafusion) &&
               compareRegionStatus(lhs.eaAccounts, rhs.eaAccounts) &&
               compareRegionStatus(lhs.apexOauthCrossplay, rhs.apexOauthCrossplay)
    }
    
    private func compareRegionStatus(_ lhs: RegionStatus, _ rhs: RegionStatus) -> Bool {
        return compareServerRegion(lhs.euWest, rhs.euWest) &&
               compareServerRegion(lhs.euEast, rhs.euEast) &&
               compareServerRegion(lhs.usWest, rhs.usWest) &&
               compareServerRegion(lhs.usCentral, rhs.usCentral) &&
               compareServerRegion(lhs.usEast, rhs.usEast) &&
               compareServerRegion(lhs.southAmerica, rhs.southAmerica) &&
               compareServerRegion(lhs.asia, rhs.asia)
    }
    
    private func compareServerRegion(_ lhs: ServerRegion, _ rhs: ServerRegion) -> Bool {
        return lhs.status == rhs.status &&
               lhs.httpCode == rhs.httpCode &&
               lhs.responseTime == rhs.responseTime &&
               lhs.queryTimestamp == rhs.queryTimestamp
    }
}

class MockServerStatusController: ObservableObject {
    @Published var serverStatus: ServerStatus?
    @Published var selectedServerType: ServerType = .origin
    @Published var currentRegionStatus: [RegionStatusData] = []
    
    var mockAPIService: MockApexAPIService
    var fetchServerStatusCalled = false
    var updateCurrentRegionStatusCalled = false
    
    init(mockAPIService: MockApexAPIService) {
        self.mockAPIService = mockAPIService
    }
    
    func fetchServerStatus() {
        fetchServerStatusCalled = true
        serverStatus = mockAPIService.mockServerStatus
        updateCurrentRegionStatus()
    }
    
    func updateCurrentRegionStatus() {
        updateCurrentRegionStatusCalled = true
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
