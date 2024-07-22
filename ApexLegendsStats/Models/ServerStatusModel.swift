//
//  ServerStatusModel.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import Foundation

struct ServerStatus: Codable {
    let originLogin: RegionStatus
    let eaNovafusion: RegionStatus
    let eaAccounts: RegionStatus
    let apexOauthCrossplay: RegionStatus
    
    enum CodingKeys: String, CodingKey {
        case originLogin = "Origin_login"
        case eaNovafusion = "EA_novafusion"
        case eaAccounts = "EA_accounts"
        case apexOauthCrossplay = "ApexOauth_Crossplay"
    }
}

struct RegionStatus: Codable {
    let euWest: ServerRegion
    let euEast: ServerRegion
    let usWest: ServerRegion
    let usCentral: ServerRegion
    let usEast: ServerRegion
    let southAmerica: ServerRegion
    let asia: ServerRegion
    
    enum CodingKeys: String, CodingKey {
        case euWest = "EU-West"
        case euEast = "EU-East"
        case usWest = "US-West"
        case usCentral = "US-Central"
        case usEast = "US-East"
        case southAmerica = "SouthAmerica"
        case asia = "Asia"
    }
}

struct ServerRegion: Codable {
    let status: String
    let httpCode: Int
    let responseTime: Int
    let queryTimestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case httpCode = "HTTPCode"
        case responseTime = "ResponseTime"
        case queryTimestamp = "QueryTimestamp"
    }
}
