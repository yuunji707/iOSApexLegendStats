//
//  MapRotationModelTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
@testable import ApexLegendsStats

class MapRotationModelTests: XCTestCase {

    func testMapRotationResponseDecoding() throws {
        let json = """
        {
            "battle_royale": {
                "current": {
                    "start": 1626984000,
                    "end": 1627027200,
                    "readableDate_start": "2024-07-22 18:00:00",
                    "readableDate_end": "2024-07-23 06:00:00",
                    "map": "World's Edge",
                    "code": "worlds_edge_rotation",
                    "DurationInSecs": 43200,
                    "DurationInMinutes": 720,
                    "asset": "https://example.com/worlds_edge.jpg",
                    "remainingMins": 200
                },
                "next": {
                    "start": 1627027200,
                    "end": 1627070400,
                    "readableDate_start": "2024-07-23 06:00:00",
                    "readableDate_end": "2024-07-23 18:00:00",
                    "map": "Olympus",
                    "code": "olympus_rotation",
                    "DurationInSecs": 43200,
                    "DurationInMinutes": 720,
                    "asset": "https://example.com/olympus.jpg"
                }
            },
            "ranked": {
                "current": {
                    "start": 1626984000,
                    "end": 1627027200,
                    "readableDate_start": "2024-07-22 18:00:00",
                    "readableDate_end": "2024-07-23 06:00:00",
                    "map": "Kings Canyon",
                    "code": "kings_canyon_rotation",
                    "DurationInSecs": 43200,
                    "DurationInMinutes": 720,
                    "asset": "https://example.com/kings_canyon.jpg",
                    "remainingTimer": "03:20:00"
                },
                "next": {
                    "start": 1627027200,
                    "end": 1627070400,
                    "readableDate_start": "2024-07-23 06:00:00",
                    "readableDate_end": "2024-07-23 18:00:00",
                    "map": "World's Edge",
                    "code": "worlds_edge_rotation",
                    "DurationInSecs": 43200,
                    "DurationInMinutes": 720,
                    "asset": "https://example.com/worlds_edge.jpg"
                }
            },
            "ltm": {
                "current": {
                    "start": 1626984000,
                    "end": 1627027200,
                    "readableDate_start": "2024-07-22 18:00:00",
                    "readableDate_end": "2024-07-23 06:00:00",
                    "map": "Arenas: Party Crasher",
                    "code": "arenas_party_crasher",
                    "DurationInSecs": 43200,
                    "DurationInMinutes": 720,
                    "asset": "https://example.com/party_crasher.jpg",
                    "eventName": "Arenas"
                },
                "next": {
                    "start": 1627027200,
                    "end": 1627070400,
                    "readableDate_start": "2024-07-23 06:00:00",
                    "readableDate_end": "2024-07-23 18:00:00",
                    "map": "Arenas: Phase Runner",
                    "code": "arenas_phase_runner",
                    "DurationInSecs": 43200,
                    "DurationInMinutes": 720,
                    "asset": "https://example.com/phase_runner.jpg",
                    "eventName": "Arenas"
                }
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let mapRotation = try decoder.decode(MapRotationResponse.self, from: json)

        XCTAssertEqual(mapRotation.battleRoyale.current.map, "World's Edge")
        XCTAssertEqual(mapRotation.battleRoyale.next.map, "Olympus")
        XCTAssertEqual(mapRotation.ranked.current.map, "Kings Canyon")
        XCTAssertEqual(mapRotation.ranked.next.map, "World's Edge")
        XCTAssertEqual(mapRotation.ltm.current.map, "Arenas: Party Crasher")
        XCTAssertEqual(mapRotation.ltm.next.map, "Arenas: Phase Runner")

        XCTAssertEqual(mapRotation.battleRoyale.current.remainingMins, 200)
        XCTAssertNil(mapRotation.battleRoyale.current.remainingTimer)
        XCTAssertNil(mapRotation.battleRoyale.current.eventName)

        XCTAssertEqual(mapRotation.ranked.current.remainingTimer, "03:20:00")
        XCTAssertNil(mapRotation.ranked.current.remainingMins)

        XCTAssertEqual(mapRotation.ltm.current.eventName, "Arenas")
        XCTAssertNil(mapRotation.ltm.current.remainingMins)
        XCTAssertNil(mapRotation.ltm.current.remainingTimer)
    }

    func testMapInfoOptionalFields() throws {
        let json = """
        {
            "start": 1626984000,
            "end": 1627027200,
            "readableDate_start": "2024-07-22 18:00:00",
            "readableDate_end": "2024-07-23 06:00:00",
            "map": "World's Edge",
            "code": "worlds_edge_rotation",
            "DurationInSecs": 43200,
            "DurationInMinutes": 720,
            "asset": "https://example.com/worlds_edge.jpg"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let mapInfo = try decoder.decode(MapInfo.self, from: json)

        XCTAssertNil(mapInfo.remainingSecs)
        XCTAssertNil(mapInfo.remainingMins)
        XCTAssertNil(mapInfo.remainingTimer)
        XCTAssertNil(mapInfo.eventName)
    }

    func testInvalidMapRotationResponseDecoding() {
        let invalidJson = "{ \"invalid\": \"data\" }".data(using: .utf8)!
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(MapRotationResponse.self, from: invalidJson)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}
