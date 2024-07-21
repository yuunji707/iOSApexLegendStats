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
    let current: MapInfo
    let next: MapInfo
}

struct MapInfo: Codable {
    let map: String
    let remainingTimer: String?
    let asset: String
    let eventName: String?
}

struct PlayerStats: Codable {
    let name: String
    let level: Int
    let kills: Int
    // Add more fields as needed
}
