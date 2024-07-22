//
//  MapRotationModel.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
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
