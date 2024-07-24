//
//  MapRotationControllerTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
import RxSwift
import RxTest
@testable import ApexLegendsStats

class TestableMapRotationController: MapRotationController {
    var mockAPIService: ApexAPIService

    init(mockAPIService: ApexAPIService) {
        self.mockAPIService = mockAPIService
        super.init()
    }

    var apiService: ApexAPIService {
        return mockAPIService
    }
}

class MapRotationControllerTests: XCTestCase {
    var controller: TestableMapRotationController!
    var mockAPIService: MockApexAPIService!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPIService = MockApexAPIService()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        controller = TestableMapRotationController(mockAPIService: mockAPIService)
    }

    override func tearDownWithError() throws {
        controller = nil
        mockAPIService = nil
        scheduler = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    func testInitialization() {
        XCTAssertNil(controller.battleRoyale)
        XCTAssertNil(controller.ranked)
        XCTAssertNil(controller.mixtape)
        XCTAssertNil(controller.errorMessage)
        XCTAssertFalse(controller.isLoading)
    }

    func testFetchMapRotationSuccess() {
        let expectation = XCTestExpectation(description: "Fetch map rotation")
        
        let mockResponse = MapRotationResponse(
            battleRoyale: MapRotation(current: MapInfo(start: 0, end: 100, readableDate_start: "", readableDate_end: "", map: "World's Edge", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: 100, remainingMins: 1, remainingTimer: "01:40", eventName: nil), next: MapInfo(start: 100, end: 200, readableDate_start: "", readableDate_end: "", map: "Kings Canyon", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: nil, remainingMins: nil, remainingTimer: nil, eventName: nil)),
            ranked: MapRotation(current: MapInfo(start: 0, end: 100, readableDate_start: "", readableDate_end: "", map: "Olympus", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: 100, remainingMins: 1, remainingTimer: "01:40", eventName: nil), next: MapInfo(start: 100, end: 200, readableDate_start: "", readableDate_end: "", map: "Storm Point", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: nil, remainingMins: nil, remainingTimer: nil, eventName: nil)),
            ltm: MapRotation(current: MapInfo(start: 0, end: 100, readableDate_start: "", readableDate_end: "", map: "Control", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: 100, remainingMins: 1, remainingTimer: "01:40", eventName: "LTM"), next: MapInfo(start: 100, end: 200, readableDate_start: "", readableDate_end: "", map: "Arenas", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: nil, remainingMins: nil, remainingTimer: nil, eventName: "LTM"))
        )
        
        mockAPIService.mockMapRotationResponse = Observable.just(mockResponse)

        controller.fetchMapRotation()

        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        if result == .timedOut {
            XCTFail("Timed out waiting for expectation")
        }

        XCTAssertEqual(self.controller.battleRoyale?.current.map, "World's Edge")
        XCTAssertEqual(self.controller.ranked?.current.map, "Olympus")
        XCTAssertEqual(self.controller.mixtape?.current.map, "Control")
        XCTAssertFalse(self.controller.isLoading)
        XCTAssertNil(self.controller.errorMessage)
        XCTAssertTrue(self.mockAPIService.fetchMapRotationCalled)
    }

    func testFetchMapRotationFailure() {
        let expectation = XCTestExpectation(description: "Fetch map rotation failure")
        
        let mockError = NSError(domain: "com.apexlegendsstats.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "API Error"])
        mockAPIService.mockMapRotationResponse = Observable.error(mockError)

        controller.fetchMapRotation()

        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        if result == .timedOut {
            XCTFail("Timed out waiting for expectation")
        }

        XCTAssertNil(self.controller.battleRoyale)
        XCTAssertNil(self.controller.ranked)
        XCTAssertNil(self.controller.mixtape)
        XCTAssertFalse(self.controller.isLoading)
        XCTAssertEqual(self.controller.errorMessage, "Error: API Error")
        XCTAssertTrue(self.mockAPIService.fetchMapRotationCalled)
    }

    func testTimerUpdates() {
        let mockResponse = MapRotationResponse(
            battleRoyale: MapRotation(current: MapInfo(start: 0, end: 100, readableDate_start: "", readableDate_end: "", map: "World's Edge", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: 100, remainingMins: 1, remainingTimer: "01:40", eventName: nil), next: MapInfo(start: 100, end: 200, readableDate_start: "", readableDate_end: "", map: "Kings Canyon", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: nil, remainingMins: nil, remainingTimer: nil, eventName: nil)),
            ranked: MapRotation(current: MapInfo(start: 0, end: 100, readableDate_start: "", readableDate_end: "", map: "Olympus", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: 100, remainingMins: 1, remainingTimer: "01:40", eventName: nil), next: MapInfo(start: 100, end: 200, readableDate_start: "", readableDate_end: "", map: "Storm Point", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: nil, remainingMins: nil, remainingTimer: nil, eventName: nil)),
            ltm: MapRotation(current: MapInfo(start: 0, end: 100, readableDate_start: "", readableDate_end: "", map: "Control", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: 100, remainingMins: 1, remainingTimer: "01:40", eventName: "LTM"), next: MapInfo(start: 100, end: 200, readableDate_start: "", readableDate_end: "", map: "Arenas", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: nil, remainingMins: nil, remainingTimer: nil, eventName: "LTM"))
        )
        
        mockAPIService.mockMapRotationResponse = Observable.just(mockResponse)

        controller.fetchMapRotation()

        let expectation = XCTestExpectation(description: "Timer update")
        let result = XCTWaiter.wait(for: [expectation], timeout: 10.0)
        if result == .timedOut {
            XCTFail("Timed out waiting for timer update")
        }

        XCTAssertEqual(controller.battleRoyale?.current.remainingSecs, 90)
        XCTAssertEqual(controller.battleRoyale?.current.remainingTimer, "01:30")
        XCTAssertEqual(controller.ranked?.current.remainingSecs, 90)
        XCTAssertEqual(controller.ranked?.current.remainingTimer, "01:30")
        XCTAssertEqual(controller.mixtape?.current.remainingSecs, 90)
        XCTAssertEqual(controller.mixtape?.current.remainingTimer, "01:30")
    }

    func testTimerExpiration() {
        let mockResponse = MapRotationResponse(
            battleRoyale: MapRotation(current: MapInfo(start: 0, end: 100, readableDate_start: "", readableDate_end: "", map: "World's Edge", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: 5, remainingMins: 0, remainingTimer: "00:05", eventName: nil), next: MapInfo(start: 100, end: 200, readableDate_start: "", readableDate_end: "", map: "Kings Canyon", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: nil, remainingMins: nil, remainingTimer: nil, eventName: nil)),
            ranked: MapRotation(current: MapInfo(start: 0, end: 100, readableDate_start: "", readableDate_end: "", map: "Olympus", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: 5, remainingMins: 0, remainingTimer: "00:05", eventName: nil), next: MapInfo(start: 100, end: 200, readableDate_start: "", readableDate_end: "", map: "Storm Point", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: nil, remainingMins: nil, remainingTimer: nil, eventName: nil)),
            ltm: MapRotation(current: MapInfo(start: 0, end: 100, readableDate_start: "", readableDate_end: "", map: "Control", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: 5, remainingMins: 0, remainingTimer: "00:05", eventName: "LTM"), next: MapInfo(start: 100, end: 200, readableDate_start: "", readableDate_end: "", map: "Arenas", code: "", DurationInSecs: 100, DurationInMinutes: 1, asset: "", remainingSecs: nil, remainingMins: nil, remainingTimer: nil, eventName: "LTM"))
        )
        
        mockAPIService.mockMapRotationResponse = Observable.just(mockResponse)

        controller.fetchMapRotation()

        let expectation = XCTestExpectation(description: "Timer expiration")
        let result = XCTWaiter.wait(for: [expectation], timeout: 6.0)
        if result == .timedOut {
            XCTFail("Timed out waiting for timer expiration")
        }

        XCTAssertEqual(controller.battleRoyale?.current.remainingSecs, 0)
        XCTAssertEqual(controller.battleRoyale?.current.remainingTimer, "00:00")
        XCTAssertEqual(controller.ranked?.current.remainingSecs, 0)
        XCTAssertEqual(controller.ranked?.current.remainingTimer, "00:00")
        XCTAssertEqual(controller.mixtape?.current.remainingSecs, 0)
        XCTAssertEqual(controller.mixtape?.current.remainingTimer, "00:00")

        // Verify that fetchMapRotation is called when the timer expires
        XCTAssertTrue(mockAPIService.fetchMapRotationCalled)
    }
}
