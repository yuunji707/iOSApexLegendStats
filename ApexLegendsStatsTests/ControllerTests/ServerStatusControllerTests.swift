//
//  ServerStatusControllerTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
@testable import ApexLegendsStats

class TestableServerStatusController: ServerStatusController {
    var mockAPIService: ApexAPIService

    init(mockAPIService: ApexAPIService) {
        self.mockAPIService = mockAPIService
        super.init()
    }

    var apiService: ApexAPIService {
        return mockAPIService
    }
}

class ServerStatusControllerTests: XCTestCase {
    var sut: TestableServerStatusController!
    var mockAPIService: MockApexAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockApexAPIService()
        sut = TestableServerStatusController(mockAPIService: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testFetchServerStatus_Success() {
        // Given
        let expectedStatus = createMockServerStatus()
        mockAPIService.mockServerStatus = expectedStatus

        // When
        sut.fetchServerStatus()

        // Then
        XCTAssertEqual(sut.serverStatus?.originLogin.euWest.status, expectedStatus.originLogin.euWest.status)
        XCTAssertEqual(sut.serverStatus?.eaNovafusion.usEast.responseTime, expectedStatus.eaNovafusion.usEast.responseTime)
        XCTAssertTrue(mockAPIService.fetchServerStatusCalled)
    }

    func testFetchServerStatus_Failure() {
        // Given
        mockAPIService.mockServerStatus = nil

        // When
        sut.fetchServerStatus()

        // Then
        XCTAssertNil(sut.serverStatus)
        XCTAssertTrue(mockAPIService.fetchServerStatusCalled)
    }

    func testUpdateCurrentRegionStatus_Origin() {
        // Given
        sut.serverStatus = createMockServerStatus()
        sut.selectedServerType = .origin

        // When
        sut.updateCurrentRegionStatus()

        // Then
        XCTAssertEqual(sut.currentRegionStatus.count, 7)
        XCTAssertEqual(sut.currentRegionStatus[0].name, "EU West")
        XCTAssertEqual(sut.currentRegionStatus[0].status, "UP")
        XCTAssertEqual(sut.currentRegionStatus[0].responseTime, 100)
    }

    func testUpdateCurrentRegionStatus_EaNova() {
        // Given
        sut.serverStatus = createMockServerStatus()
        sut.selectedServerType = .eaNova

        // When
        sut.updateCurrentRegionStatus()

        // Then
        XCTAssertEqual(sut.currentRegionStatus.count, 7)
        XCTAssertEqual(sut.currentRegionStatus[1].name, "EU East")
        XCTAssertEqual(sut.currentRegionStatus[1].status, "UP")
        XCTAssertEqual(sut.currentRegionStatus[1].responseTime, 110)
    }

    func testUpdateCurrentRegionStatus_EaAccounts() {
        // Given
        sut.serverStatus = createMockServerStatus()
        sut.selectedServerType = .eaAccounts

        // When
        sut.updateCurrentRegionStatus()

        // Then
        XCTAssertEqual(sut.currentRegionStatus.count, 7)
        XCTAssertEqual(sut.currentRegionStatus[2].name, "US West")
        XCTAssertEqual(sut.currentRegionStatus[2].status, "UP")
        XCTAssertEqual(sut.currentRegionStatus[2].responseTime, 120)
    }

    func testUpdateCurrentRegionStatus_Crossplay() {
        // Given
        sut.serverStatus = createMockServerStatus()
        sut.selectedServerType = .crossplay

        // When
        sut.updateCurrentRegionStatus()

        // Then
        XCTAssertEqual(sut.currentRegionStatus.count, 7)
        XCTAssertEqual(sut.currentRegionStatus[3].name, "US Central")
        XCTAssertEqual(sut.currentRegionStatus[3].status, "UP")
        XCTAssertEqual(sut.currentRegionStatus[3].responseTime, 130)
    }

    func testUpdateCurrentRegionStatus_NilServerStatus() {
        // Given
        sut.serverStatus = nil
        sut.selectedServerType = .origin

        // When
        sut.updateCurrentRegionStatus()

        // Then
        XCTAssertTrue(sut.currentRegionStatus.isEmpty)
    }

    // Helper method to create a mock ServerStatus
    private func createMockServerStatus() -> ServerStatus {
        return ServerStatus(
            originLogin: createMockRegionStatus(),
            eaNovafusion: createMockRegionStatus(),
            eaAccounts: createMockRegionStatus(),
            apexOauthCrossplay: createMockRegionStatus()
        )
    }

    private func createMockRegionStatus() -> RegionStatus {
        return RegionStatus(
            euWest: ServerRegion(status: "UP", httpCode: 200, responseTime: 100, queryTimestamp: 1626912000),
            euEast: ServerRegion(status: "UP", httpCode: 200, responseTime: 110, queryTimestamp: 1626912000),
            usWest: ServerRegion(status: "UP", httpCode: 200, responseTime: 120, queryTimestamp: 1626912000),
            usCentral: ServerRegion(status: "UP", httpCode: 200, responseTime: 130, queryTimestamp: 1626912000),
            usEast: ServerRegion(status: "UP", httpCode: 200, responseTime: 140, queryTimestamp: 1626912000),
            southAmerica: ServerRegion(status: "UP", httpCode: 200, responseTime: 150, queryTimestamp: 1626912000),
            asia: ServerRegion(status: "UP", httpCode: 200, responseTime: 160, queryTimestamp: 1626912000)
        )
    }
}
