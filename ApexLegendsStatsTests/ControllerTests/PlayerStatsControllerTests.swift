//
//  PlayerStatsControllerTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
@testable import ApexLegendsStats

// Testable version of PlayerStatsController
class TestablePlayerStatsController: PlayerStatsController {
    var testableAPIService: ApexAPIService
    
    init(apiService: ApexAPIService) {
        self.testableAPIService = apiService
        super.init()
    }
    
    var apiService: ApexAPIService {
        return testableAPIService
    }
}

class PlayerStatsControllerTests: XCTestCase {
    var sut: TestablePlayerStatsController!
    var mockAPIService: MockApexAPIService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPIService = MockApexAPIService()
        sut = TestablePlayerStatsController(apiService: mockAPIService)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockAPIService = nil
        try super.tearDownWithError()
    }

    func testInitialState() {
        XCTAssertEqual(sut.playerName, "")
        XCTAssertEqual(sut.platform, "PC")
        XCTAssertNil(sut.stats)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func testFetchPlayerStatsWithEmptyName() {
        sut.playerName = ""
        sut.fetchPlayerStats()

        XCTAssertEqual(sut.errorMessage, "Please enter a player name")
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(mockAPIService.fetchPlayerStatsCalled)
    }

    func testFetchPlayerStatsSuccess() {
        let expectation = XCTestExpectation(description: "Fetch player stats")
        let mockStats = PlayerStats(
            global: GlobalStats(name: "TestPlayer", level: 100, toNextLevelPercent: 50, rank: Rank(rankName: "Diamond", rankDiv: 4, rankImg: "diamond.png")),
            realtime: RealtimeStats(selectedLegend: "Wraith"),
            legends: LegendsStats(selected: SelectedLegend(LegendName: "Wraith", data: [LegendData(name: "Kills", value: 1000)], ImgAssets: LegendImgAssets(icon: "wraith.png")))
        )
        mockAPIService.mockPlayerStats = mockStats

        sut.playerName = "TestPlayer"
        sut.fetchPlayerStats()

        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        if result == .timedOut {
            XCTFail("Timed out waiting for expectation")
        }

        XCTAssertTrue(self.mockAPIService.fetchPlayerStatsCalled)
        XCTAssertEqual(self.sut.stats?.global.name, mockStats.global.name)
        XCTAssertNil(self.sut.errorMessage)
        XCTAssertFalse(self.sut.isLoading)
    }

    func testFetchPlayerStatsFailure() {
        let expectation = XCTestExpectation(description: "Fetch player stats failure")
        mockAPIService.mockPlayerStats = nil // This will cause the fetch to fail

        sut.playerName = "NonExistentPlayer"
        sut.fetchPlayerStats()

        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        if result == .timedOut {
            XCTFail("Timed out waiting for expectation")
        }

        XCTAssertTrue(self.mockAPIService.fetchPlayerStatsCalled)
        XCTAssertNil(self.sut.stats)
        XCTAssertNotNil(self.sut.errorMessage)
        XCTAssertTrue(self.sut.errorMessage?.starts(with: "Error:") ?? false)
        XCTAssertFalse(self.sut.isLoading)
    }

    func testFetchPlayerStatsLoadingState() {
        sut.playerName = "TestPlayer"
        sut.fetchPlayerStats()

        XCTAssertTrue(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func testFetchPlayerStatsWithDifferentPlatform() {
        let expectation = XCTestExpectation(description: "Fetch player stats with different platform")
        let mockStats = PlayerStats(
            global: GlobalStats(name: "ConsolePro", level: 200, toNextLevelPercent: 75, rank: Rank(rankName: "Predator", rankDiv: 1, rankImg: "predator.png")),
            realtime: RealtimeStats(selectedLegend: "Octane"),
            legends: LegendsStats(selected: SelectedLegend(LegendName: "Octane", data: [LegendData(name: "Wins", value: 500)], ImgAssets: LegendImgAssets(icon: "octane.png")))
        )
        mockAPIService.mockPlayerStats = mockStats

        sut.playerName = "ConsolePro"
        sut.platform = "PS4"
        sut.fetchPlayerStats()

        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        if result == .timedOut {
            XCTFail("Timed out waiting for expectation")
        }

        XCTAssertTrue(self.mockAPIService.fetchPlayerStatsCalled)
        XCTAssertEqual(self.sut.stats?.global.name, mockStats.global.name)
        XCTAssertEqual(self.sut.platform, "PS4")
        XCTAssertNil(self.sut.errorMessage)
        XCTAssertFalse(self.sut.isLoading)
    }
}
