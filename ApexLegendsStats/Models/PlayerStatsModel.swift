//
//  PlayerStatsModel.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import Foundation

/// Represents the overall statistics for a player
struct PlayerStats: Codable {
    let global: GlobalStats
    let realtime: RealtimeStats
    let legends: LegendsStats
}

/// Global statistics for a player
struct GlobalStats: Codable {
    let name: String
    let level: Int
    let toNextLevelPercent: Int
    let rank: Rank
}

/// Represents a player's rank
struct Rank: Codable {
    let rankName: String
    let rankDiv: Int
    let rankImg: String
}

/// Real-time statistics for a player
struct RealtimeStats: Codable {
    let selectedLegend: String
}

/// Statistics for a player's legends
struct LegendsStats: Codable {
    let selected: SelectedLegend
}

/// Represents the currently selected legend and its statistics
struct SelectedLegend: Codable {
    let LegendName: String
    let data: [LegendData]
    let ImgAssets: LegendImgAssets
}

/// Individual statistic for a legend
struct LegendData: Codable {
    let name: String
    let value: Int
}

/// Image assets for a legend
struct LegendImgAssets: Codable {
    let icon: String
}
