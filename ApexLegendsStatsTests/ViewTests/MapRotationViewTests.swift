//
//  MapRotationViewTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
import SwiftUI
import RxSwift
@testable import ApexLegendsStats

class MapRotationViewTests: XCTestCase {
    var sut: MapRotationView!
    var mockController: MockMapRotationController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockController = MockMapRotationController()
        sut = MapRotationView()
        sut.controller = mockController
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockController = nil
        try super.tearDownWithError()
    }
    
    func testInitialState() {
        XCTAssertTrue(mockController.isLoading)
        XCTAssertNil(mockController.errorMessage)
        XCTAssertNil(mockController.battleRoyale)
        XCTAssertNil(mockController.ranked)
        XCTAssertNil(mockController.mixtape)
    }
    
    func testFetchMapRotationSuccess() {
        let expectation = XCTestExpectation(description: "Fetch map rotation")
        
        mockController.fetchMapRotationResult = .success(createMockMapRotationResponse())
        
        mockController.fetchMapRotation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.mockController.isLoading)
            XCTAssertNil(self.mockController.errorMessage)
            XCTAssertNotNil(self.mockController.battleRoyale)
            XCTAssertNotNil(self.mockController.ranked)
            XCTAssertNotNil(self.mockController.mixtape)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchMapRotationFailure() {
        let expectation = XCTestExpectation(description: "Fetch map rotation error")
        
        mockController.fetchMapRotationResult = .failure(NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"]))
        
        mockController.fetchMapRotation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.mockController.isLoading)
            XCTAssertEqual(self.mockController.errorMessage, "Error: Test error")
            XCTAssertNil(self.mockController.battleRoyale)
            XCTAssertNil(self.mockController.ranked)
            XCTAssertNil(self.mockController.mixtape)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testTimerUpdates() {
        let expectation = XCTestExpectation(description: "Timer updates")
        
        mockController.battleRoyale = createMockMapRotation(remainingSecs: 2)
        mockController.simulateTimerTick()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockController.battleRoyale?.current.remainingSecs, 1)
            XCTAssertFalse(self.mockController.fetchMapRotationCalled)
            
            self.mockController.simulateTimerTick()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self.mockController.battleRoyale?.current.remainingSecs, 0)
                XCTAssertTrue(self.mockController.fetchMapRotationCalled)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Helper methods to create mock data
    private func createMockMapRotationResponse() -> MapRotationResponse {
        return MapRotationResponse(
            battleRoyale: createMockMapRotation(),
            ranked: createMockMapRotation(),
            ltm: createMockMapRotation()
        )
    }
    
    private func createMockMapRotation(remainingSecs: Int = 1800) -> MapRotation {
        return MapRotation(
            current: createMockMapInfo(remainingSecs: remainingSecs),
            next: createMockMapInfo()
        )
    }
    
    private func createMockMapInfo(remainingSecs: Int = 1800) -> MapInfo {
        return MapInfo(
            start: Int(Date().timeIntervalSince1970),
            end: Int(Date().timeIntervalSince1970) + remainingSecs,
            readableDate_start: "2024-07-24 12:00:00",
            readableDate_end: "2024-07-24 12:30:00",
            map: "Test Map Name",
            code: "test_map",
            DurationInSecs: remainingSecs,
            DurationInMinutes: remainingSecs / 60,
            asset: "https://example.com/test_map.jpg",
            remainingSecs: remainingSecs,
            remainingMins: remainingSecs / 60,
            remainingTimer: "00:30:00",
            eventName: "Test Event"
        )
    }
}

// Mock MapRotationController for testing
class MockMapRotationController: MapRotationController {
    var fetchMapRotationResult: Result<MapRotationResponse, Error>?
    var fetchMapRotationCalled = false
    
    override func fetchMapRotation() {
        fetchMapRotationCalled = true
        isLoading = true
        errorMessage = nil
        
        guard let result = fetchMapRotationResult else {
            fatalError("fetchMapRotationResult not set")
        }
        
        switch result {
        case .success(let response):
            battleRoyale = response.battleRoyale
            ranked = response.ranked
            mixtape = response.ltm
            isLoading = false
        case .failure(let error):
            errorMessage = "Error: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func simulateTimerTick() {
        updateTimers()
    }
    
    override func updateTimers() {
        let rotations = [battleRoyale, ranked, mixtape]
        
        for (index, rotation) in rotations.enumerated() {
            guard var updatedRotation = rotation else { continue }
            if var remainingSecs = updatedRotation.current.remainingSecs {
                remainingSecs -= 1
                
                if remainingSecs <= 0 {
                    fetchMapRotation()
                    return
                }
                
                var updatedMapInfo = updatedRotation.current
                updatedMapInfo.remainingSecs = remainingSecs
                updatedMapInfo.remainingTimer = formatRemainingTime(remainingSecs)
                updatedRotation.current = updatedMapInfo
                
                switch index {
                case 0: battleRoyale = updatedRotation
                case 1: ranked = updatedRotation
                case 2: mixtape = updatedRotation
                default: break
                }
            }
        }
    }
    
    private func formatRemainingTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            return String(format: "%02d:%02d", minutes, remainingSeconds)
        }
    }
}
