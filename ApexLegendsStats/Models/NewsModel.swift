//
//  NewsModel.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import Foundation

struct NewsItem: Codable, Identifiable {
    let title: String
    let link: String
    let img: String
    let short_desc: String
    
    var id: String { link }
}
