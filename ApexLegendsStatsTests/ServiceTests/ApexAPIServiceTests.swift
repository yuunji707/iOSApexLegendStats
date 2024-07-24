//
//  ApexAPIServiceTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
import RxSwift
import RxTest
@testable import ApexLegendsStats

class ApexAPIServiceTests: XCTestCase {
    var apiService: ApexAPIService!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        apiService = ApexAPIService()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        apiService = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    func testFetchMapRotation() {
        let expectation = self.expectation(description: "Fetch map rotation")
        
        apiService.fetchMapRotation()
            .subscribe(onNext: { response in
                XCTAssertNotNil(response.battleRoyale)
                XCTAssertNotNil(response.ranked)
                XCTAssertNotNil(response.ltm)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Error fetching map rotation: \(error)")
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchPlayerStats() {
        let expectation = self.expectation(description: "Fetch player stats")
        
        Task {
            do {
                let stats = try await apiService.fetchPlayerStats(playerName: "TestPlayer", platform: "PC")
                XCTAssertNotNil(stats)
                expectation.fulfill()
            } catch {
                XCTFail("Error fetching player stats: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchNews() {
        let expectation = self.expectation(description: "Fetch news")
        
        Task {
            do {
                let news = try await apiService.fetchNews()
                XCTAssertFalse(news.isEmpty)
                expectation.fulfill()
            } catch {
                XCTFail("Error fetching news: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchServerStatus() {
        let expectation = self.expectation(description: "Fetch server status")
        
        Task {
            do {
                let status = try await apiService.fetchServerStatus()
                XCTAssertNotNil(status)
                expectation.fulfill()
            } catch {
                XCTFail("Error fetching server status: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
