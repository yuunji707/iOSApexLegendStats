//
//  ApexModels.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import Foundation

struct MapRotationResponse: Codable {
    let battleRoyale: MapRotation
    let ranked: MapRotation
    let ltm: MapRotation
    
    enum CodingKeys: String, CodingKey {
        case battleRoyale = "battle_royale"
        case ranked
        case ltm
    }
}

struct MapRotation: Codable {
    var current: MapInfo
    let next: MapInfo
}

struct MapInfo: Codable {
    let start: Int
    let end: Int
    let readableDate_start: String
    let readableDate_end: String
    let map: String
    let code: String
    let DurationInSecs: Int
    let DurationInMinutes: Int
    let asset: String
    var remainingSecs: Int?
    let remainingMins: Int?
    var remainingTimer: String? 
    let eventName: String?
}

struct NewsItem: Codable, Identifiable {
    let title: String
    let link: String
    let img: String
    let short_desc: String
    
    var id: String { link } 
}

struct PlayerStats: Codable {
    let global: GlobalStats
    let realtime: RealtimeStats
    let legends: LegendsStats
}

struct GlobalStats: Codable {
    let name: String
    let level: Int
    let toNextLevelPercent: Int
    let rank: Rank
}

struct Rank: Codable {
    let rankName: String
    let rankDiv: Int
    let rankImg: String
}

struct RealtimeStats: Codable {
    let selectedLegend: String
}

struct LegendsStats: Codable {
    let selected: SelectedLegend
}

struct SelectedLegend: Codable {
    let LegendName: String
    let data: [LegendData]
    let ImgAssets: LegendImgAssets
}

struct LegendData: Codable {
    let name: String
    let value: Int
}

struct LegendImgAssets: Codable {
    let icon: String
}

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
