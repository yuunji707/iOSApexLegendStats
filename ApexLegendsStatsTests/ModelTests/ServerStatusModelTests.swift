//
//  ServerStatusModelTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
@testable import ApexLegendsStats

class ServerStatusModelTests: XCTestCase {

    func testServerStatusDecoding() throws {
        let json = """
        {
            "Origin_login": {
                "EU-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 42,
                    "QueryTimestamp": 1626984000
                },
                "EU-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 38,
                    "QueryTimestamp": 1626984000
                },
                "US-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 55,
                    "QueryTimestamp": 1626984000
                },
                "US-Central": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 48,
                    "QueryTimestamp": 1626984000
                },
                "US-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 45,
                    "QueryTimestamp": 1626984000
                },
                "SouthAmerica": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 60,
                    "QueryTimestamp": 1626984000
                },
                "Asia": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 70,
                    "QueryTimestamp": 1626984000
                }
            },
            "EA_novafusion": {
                "EU-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 40,
                    "QueryTimestamp": 1626984000
                },
                "EU-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 35,
                    "QueryTimestamp": 1626984000
                },
                "US-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 50,
                    "QueryTimestamp": 1626984000
                },
                "US-Central": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 45,
                    "QueryTimestamp": 1626984000
                },
                "US-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 42,
                    "QueryTimestamp": 1626984000
                },
                "SouthAmerica": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 58,
                    "QueryTimestamp": 1626984000
                },
                "Asia": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 65,
                    "QueryTimestamp": 1626984000
                }
            },
            "EA_accounts": {
                "EU-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 41,
                    "QueryTimestamp": 1626984000
                },
                "EU-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 36,
                    "QueryTimestamp": 1626984000
                },
                "US-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 52,
                    "QueryTimestamp": 1626984000
                },
                "US-Central": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 46,
                    "QueryTimestamp": 1626984000
                },
                "US-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 43,
                    "QueryTimestamp": 1626984000
                },
                "SouthAmerica": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 59,
                    "QueryTimestamp": 1626984000
                },
                "Asia": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 66,
                    "QueryTimestamp": 1626984000
                }
            },
            "ApexOauth_Crossplay": {
                "EU-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 43,
                    "QueryTimestamp": 1626984000
                },
                "EU-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 37,
                    "QueryTimestamp": 1626984000
                },
                "US-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 54,
                    "QueryTimestamp": 1626984000
                },
                "US-Central": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 47,
                    "QueryTimestamp": 1626984000
                },
                "US-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 44,
                    "QueryTimestamp": 1626984000
                },
                "SouthAmerica": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 61,
                    "QueryTimestamp": 1626984000
                },
                "Asia": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 68,
                    "QueryTimestamp": 1626984000
                }
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let serverStatus = try decoder.decode(ServerStatus.self, from: json)

        XCTAssertEqual(serverStatus.originLogin.euWest.status, "UP")
        XCTAssertEqual(serverStatus.originLogin.euWest.httpCode, 200)
        XCTAssertEqual(serverStatus.originLogin.euWest.responseTime, 42)
        XCTAssertEqual(serverStatus.originLogin.euWest.queryTimestamp, 1626984000)

        XCTAssertEqual(serverStatus.eaNovafusion.usEast.status, "UP")
        XCTAssertEqual(serverStatus.eaNovafusion.usEast.httpCode, 200)
        XCTAssertEqual(serverStatus.eaNovafusion.usEast.responseTime, 42)
        XCTAssertEqual(serverStatus.eaNovafusion.usEast.queryTimestamp, 1626984000)

        XCTAssertEqual(serverStatus.eaAccounts.asia.status, "UP")
        XCTAssertEqual(serverStatus.eaAccounts.asia.httpCode, 200)
        XCTAssertEqual(serverStatus.eaAccounts.asia.responseTime, 66)
        XCTAssertEqual(serverStatus.eaAccounts.asia.queryTimestamp, 1626984000)

        XCTAssertEqual(serverStatus.apexOauthCrossplay.southAmerica.status, "UP")
        XCTAssertEqual(serverStatus.apexOauthCrossplay.southAmerica.httpCode, 200)
        XCTAssertEqual(serverStatus.apexOauthCrossplay.southAmerica.responseTime, 61)
        XCTAssertEqual(serverStatus.apexOauthCrossplay.southAmerica.queryTimestamp, 1626984000)
    }

    func testServerStatusWithMixedStatuses() throws {
        let json = """
        {
            "Origin_login": {
                "EU-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 42,
                    "QueryTimestamp": 1626984000
                },
                "EU-East": {
                    "Status": "DOWN",
                    "HTTPCode": 500,
                    "ResponseTime": 0,
                    "QueryTimestamp": 1626984000
                },
                "US-West": {
                    "Status": "SLOW",
                    "HTTPCode": 200,
                    "ResponseTime": 250,
                    "QueryTimestamp": 1626984000
                },
                "US-Central": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 48,
                    "QueryTimestamp": 1626984000
                },
                "US-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 45,
                    "QueryTimestamp": 1626984000
                },
                "SouthAmerica": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 60,
                    "QueryTimestamp": 1626984000
                },
                "Asia": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 70,
                    "QueryTimestamp": 1626984000
                }
            },
            "EA_novafusion": {
                "EU-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 40,
                    "QueryTimestamp": 1626984000
                },
                "EU-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 35,
                    "QueryTimestamp": 1626984000
                },
                "US-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 50,
                    "QueryTimestamp": 1626984000
                },
                "US-Central": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 45,
                    "QueryTimestamp": 1626984000
                },
                "US-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 42,
                    "QueryTimestamp": 1626984000
                },
                "SouthAmerica": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 58,
                    "QueryTimestamp": 1626984000
                },
                "Asia": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 65,
                    "QueryTimestamp": 1626984000
                }
            },
            "EA_accounts": {
                "EU-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 41,
                    "QueryTimestamp": 1626984000
                },
                "EU-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 36,
                    "QueryTimestamp": 1626984000
                },
                "US-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 52,
                    "QueryTimestamp": 1626984000
                },
                "US-Central": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 46,
                    "QueryTimestamp": 1626984000
                },
                "US-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 43,
                    "QueryTimestamp": 1626984000
                },
                "SouthAmerica": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 59,
                    "QueryTimestamp": 1626984000
                },
                "Asia": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 66,
                    "QueryTimestamp": 1626984000
                }
            },
            "ApexOauth_Crossplay": {
                "EU-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 43,
                    "QueryTimestamp": 1626984000
                },
                "EU-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 37,
                    "QueryTimestamp": 1626984000
                },
                "US-West": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 54,
                    "QueryTimestamp": 1626984000
                },
                "US-Central": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 47,
                    "QueryTimestamp": 1626984000
                },
                "US-East": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 44,
                    "QueryTimestamp": 1626984000
                },
                "SouthAmerica": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 61,
                    "QueryTimestamp": 1626984000
                },
                "Asia": {
                    "Status": "UP",
                    "HTTPCode": 200,
                    "ResponseTime": 68,
                    "QueryTimestamp": 1626984000
                }
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let serverStatus = try decoder.decode(ServerStatus.self, from: json)

        XCTAssertEqual(serverStatus.originLogin.euWest.status, "UP")
        XCTAssertEqual(serverStatus.originLogin.euWest.httpCode, 200)
        XCTAssertEqual(serverStatus.originLogin.euWest.responseTime, 42)

        XCTAssertEqual(serverStatus.originLogin.euEast.status, "DOWN")
        XCTAssertEqual(serverStatus.originLogin.euEast.httpCode, 500)
        XCTAssertEqual(serverStatus.originLogin.euEast.responseTime, 0)

        XCTAssertEqual(serverStatus.originLogin.usWest.status, "SLOW")
        XCTAssertEqual(serverStatus.originLogin.usWest.httpCode, 200)
        XCTAssertEqual(serverStatus.originLogin.usWest.responseTime, 250)

        XCTAssertEqual(serverStatus.eaNovafusion.euWest.status, "UP")
        XCTAssertEqual(serverStatus.eaNovafusion.euWest.httpCode, 200)
        XCTAssertEqual(serverStatus.eaNovafusion.euWest.status, "UP")
        XCTAssertEqual(serverStatus.eaNovafusion.euWest.httpCode, 200)
        XCTAssertEqual(serverStatus.eaNovafusion.euWest.responseTime, 40)

        XCTAssertEqual(serverStatus.eaAccounts.usWest.status, "UP")
        XCTAssertEqual(serverStatus.eaAccounts.usWest.httpCode, 200)
        XCTAssertEqual(serverStatus.eaAccounts.usWest.responseTime, 52)

        XCTAssertEqual(serverStatus.apexOauthCrossplay.asia.status, "UP")
        XCTAssertEqual(serverStatus.apexOauthCrossplay.asia.httpCode, 200)
        XCTAssertEqual(serverStatus.apexOauthCrossplay.asia.responseTime, 68)
    }

    func testInvalidServerStatusDecoding() {
        let invalidJson = """
        {
            "InvalidKey": {
                "InvalidRegion": {
                    "Status": "UNKNOWN",
                    "HTTPCode": 0,
                    "ResponseTime": -1,
                    "QueryTimestamp": 0
                }
            }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(ServerStatus.self, from: invalidJson)) { error in
            XCTAssertTrue(error is DecodingError, "Expected a DecodingError, but got \(error)")
        }
    }
}
