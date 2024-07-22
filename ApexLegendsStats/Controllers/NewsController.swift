//
//  NewsController.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import Foundation

class NewsController {
    private let apexAPIService = ApexAPIService()
    private let itemsPerPage = 5
    
    func fetchNews(page: Int) async throws -> [NewsItem] {
        let allNews = try await apexAPIService.fetchNews()
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, allNews.count)
        return Array(allNews[startIndex..<endIndex])
    }
}
