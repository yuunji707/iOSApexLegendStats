//
//  NewsController.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import Foundation

/// Controller class for fetching and managing Apex Legends news
class NewsController {
    private let apexAPIService = ApexAPIService()
    private let itemsPerPage = 5
    
    /// Fetches a paginated list of news items
    /// - Parameter page: The page number to fetch (1-based index)
    /// - Returns: An array of NewsItem objects for the requested page
    /// - Throws: Any error encountered during the API request
    func fetchNews(page: Int) async throws -> [NewsItem] {
        let allNews = try await apexAPIService.fetchNews()
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, allNews.count)
        return Array(allNews[startIndex..<endIndex])
    }
}
