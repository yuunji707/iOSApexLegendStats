//
//  PlayerStatsModel.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import Foundation

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
