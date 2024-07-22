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

struct PlayerStats: Codable {
    let name: String
    let level: Int
    let kills: Int
    // Add more fields as needed
}

struct GlobalStats: Codable {
    let name: String
    let uid: String
    let avatar: String?
    let platform: String
    let level: Int
    let toNextLevelPercent: Int
    let internalUpdateCount: Int
    let bans: Bans
    let rank: Rank
    let arena: Rank
    let battlepass: Battlepass
    let internalParsingVersion: Int
    let badges: [Badge]
    let levelPrestige: Int?
}

struct RealtimeStats: Codable {
    let lobbyState: String
    let isOnline: Int
    let isInGame: Int
    let canJoin: Int
    let partyFull: Int
    let selectedLegend: String
    let currentState: String
    let currentStateSinceTimestamp: Int
    let currentStateAsText: String
}

struct LegendsStats: Codable {
    let selected: SelectedLegend
    // You might want to add more fields here if there are other legend-related stats
}

struct SelectedLegend: Codable {
    let LegendName: String
    let data: [LegendData]
    let gameInfo: LegendGameInfo
    let ImgAssets: LegendImgAssets
}

struct LegendData: Codable {
    let name: String
    let value: Int
    let key: String
}

struct LegendGameInfo: Codable {
    let skin: String
    let skinRarity: String
    let frame: String
    let frameRarity: String
    let pose: String
    let poseRarity: String
    let intro: String
    let introRarity: String
    let badges: [LegendBadge]
}

struct LegendBadge: Codable {
    let name: String
    let value: Int
    let category: String
}

struct LegendImgAssets: Codable {
    let icon: String
    let banner: String
}

struct Bans: Codable {
    let isActive: Bool
    let remainingSeconds: Int
    let lastBanReason: String
}

struct Rank: Codable {
    let rankScore: Int
    let rankName: String
    let rankDiv: Int
    let ladderPosPlatform: Int
    let rankImg: String
    let rankedSeason: String
}

struct Battlepass: Codable {
    let level: String
    let history: [BattlepassHistory]
}

struct BattlepassHistory: Codable {
    let season: Int
    let level: Int
}

struct Badge: Codable {
    let name: String
    let value: Int
}
