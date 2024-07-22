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
