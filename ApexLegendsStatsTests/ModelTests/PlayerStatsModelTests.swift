//
//  PlayerStatsModelTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
@testable import ApexLegendsStats

class PlayerStatsModelTests: XCTestCase {

    func testPlayerStatsDecoding() throws {
        let json = """
        {
            "global": {
                "name": "PlayerOne",
                "level": 500,
                "toNextLevelPercent": 0,
                "rank": {
                    "rankName": "Predator",
                    "rankDiv": 0,
                    "rankImg": "https://api.mozambiquehe.re/assets/ranks/predator.png"
                }
            },
            "realtime": {
                "selectedLegend": "Wraith"
            },
            "legends": {
                "selected": {
                    "LegendName": "Wraith",
                    "data": [
                        {
                            "name": "Kills",
                            "value": 10000
                        },
                        {
                            "name": "Damage",
                            "value": 2000000
                        }
                    ],
                    "ImgAssets": {
                        "icon": "https://api.mozambiquehe.re/assets/icons/wraith.png"
                    }
                }
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let playerStats = try decoder.decode(PlayerStats.self, from: json)

        XCTAssertEqual(playerStats.global.name, "PlayerOne")
        XCTAssertEqual(playerStats.global.level, 500)
        XCTAssertEqual(playerStats.global.toNextLevelPercent, 0)
        XCTAssertEqual(playerStats.global.rank.rankName, "Predator")
        XCTAssertEqual(playerStats.global.rank.rankDiv, 0)
        XCTAssertEqual(playerStats.global.rank.rankImg, "https://api.mozambiquehe.re/assets/ranks/predator.png")

        XCTAssertEqual(playerStats.realtime.selectedLegend, "Wraith")

        XCTAssertEqual(playerStats.legends.selected.LegendName, "Wraith")
        XCTAssertEqual(playerStats.legends.selected.data.count, 2)
        XCTAssertEqual(playerStats.legends.selected.data[0].name, "Kills")
        XCTAssertEqual(playerStats.legends.selected.data[0].value, 10000)
        XCTAssertEqual(playerStats.legends.selected.data[1].name, "Damage")
        XCTAssertEqual(playerStats.legends.selected.data[1].value, 2000000)
        XCTAssertEqual(playerStats.legends.selected.ImgAssets.icon, "https://api.mozambiquehe.re/assets/icons/wraith.png")
    }

    func testPlayerStatsWithEmptyLegendData() throws {
        let json = """
        {
            "global": {
                "name": "PlayerTwo",
                "level": 100,
                "toNextLevelPercent": 50,
                "rank": {
                    "rankName": "Gold",
                    "rankDiv": 2,
                    "rankImg": "https://api.mozambiquehe.re/assets/ranks/gold2.png"
                }
            },
            "realtime": {
                "selectedLegend": "Lifeline"
            },
            "legends": {
                "selected": {
                    "LegendName": "Lifeline",
                    "data": [],
                    "ImgAssets": {
                        "icon": "https://api.mozambiquehe.re/assets/icons/lifeline.png"
                    }
                }
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let playerStats = try decoder.decode(PlayerStats.self, from: json)

        XCTAssertEqual(playerStats.global.name, "PlayerTwo")
        XCTAssertEqual(playerStats.global.level, 100)
        XCTAssertEqual(playerStats.global.toNextLevelPercent, 50)
        XCTAssertEqual(playerStats.global.rank.rankName, "Gold")
        XCTAssertEqual(playerStats.global.rank.rankDiv, 2)

        XCTAssertEqual(playerStats.realtime.selectedLegend, "Lifeline")

        XCTAssertEqual(playerStats.legends.selected.LegendName, "Lifeline")
        XCTAssertTrue(playerStats.legends.selected.data.isEmpty)
    }

    func testInvalidPlayerStatsDecoding() {
        let invalidJson = "{ \"invalid\": \"data\" }".data(using: .utf8)!
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(PlayerStats.self, from: invalidJson)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}
