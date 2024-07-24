//
//  NewsViewTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//


import XCTest
import SwiftUI
@testable import ApexLegendsStats

class MockNewsController: NewsController {
    var mockNews: [NewsItem] = []
    var shouldThrowError = false
    var fetchNewsCalled = false
    
    override func fetchNews(page: Int) async throws -> [NewsItem] {
        fetchNewsCalled = true
        if shouldThrowError {
            throw NSError(domain: "MockNewsController", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return Array(mockNews.prefix(5))
    }
}

// A testable version of NewsView that exposes private properties
struct TestableNewsView: View {
    @State var newsItems: [NewsItem] = []
    @State var isLoading = false
    @State var errorMessage: String?
    @State var currentPage = 1
    @State var hasMorePages = true
    
    let newsController: NewsController
    
    var body: some View {
        NewsView()
    }
    
    func loadNews() async {
        await NewsView.loadNews(newsItems: &newsItems, isLoading: &isLoading, errorMessage: &errorMessage, currentPage: currentPage, hasMorePages: &hasMorePages, newsController: newsController)
    }
    
    func loadMoreNews() async {
        await NewsView.loadMoreNews(newsItems: &newsItems, isLoading: &isLoading, errorMessage: &errorMessage, currentPage: &currentPage, hasMorePages: &hasMorePages, newsController: newsController)
    }
    
    func refreshNews() async {
        await NewsView.refreshNews(newsItems: &newsItems, isLoading: &isLoading, errorMessage: &errorMessage, currentPage: &currentPage, hasMorePages: &hasMorePages, newsController: newsController)
    }
}

class NewsViewTests: XCTestCase {
    
    var mockNewsController: MockNewsController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNewsController = MockNewsController()
    }
    
    override func tearDownWithError() throws {
        mockNewsController = nil
        try super.tearDownWithError()
    }
    
    func testNewsViewInitialState() {
        let view = TestableNewsView(newsController: mockNewsController)
        XCTAssertTrue(view.newsItems.isEmpty)
        XCTAssertFalse(view.isLoading)
        XCTAssertNil(view.errorMessage)
        XCTAssertEqual(view.currentPage, 1)
        XCTAssertTrue(view.hasMorePages)
    }
    
    func testNewsViewLoading() async {
        mockNewsController.mockNews = [
            NewsItem(title: "Test News 1", link: "https://test1.com", img: "https://test1.com/image.jpg", short_desc: "Test description 1"),
            NewsItem(title: "Test News 2", link: "https://test2.com", img: "https://test2.com/image.jpg", short_desc: "Test description 2")
        ]
        
        let view = TestableNewsView(newsController: mockNewsController)
        
        await view.loadNews()
        
        XCTAssertEqual(view.newsItems.count, 2)
        XCTAssertFalse(view.isLoading)
        XCTAssertNil(view.errorMessage)
        XCTAssertTrue(mockNewsController.fetchNewsCalled)
    }
    
    func testLoadMoreNews() async {
        mockNewsController.mockNews = Array(repeating: NewsItem(title: "Test News", link: "https://test.com", img: "https://test.com/image.jpg", short_desc: "Test description"), count: 10)
        
        let view = TestableNewsView(newsController: mockNewsController)
        
        await view.loadNews()
        XCTAssertEqual(view.newsItems.count, 5)
        
        await view.loadMoreNews()
        XCTAssertEqual(view.newsItems.count, 10)
        XCTAssertFalse(view.hasMorePages)
    }
    
    func testRefreshNews() async {
        mockNewsController.mockNews = [NewsItem(title: "Test News", link: "https://test.com", img: "https://test.com/image.jpg", short_desc: "Test description")]
        
        let view = TestableNewsView(newsController: mockNewsController)
        view.currentPage = 3
        
        await view.refreshNews()
        
        XCTAssertEqual(view.currentPage, 1)
        XCTAssertTrue(view.hasMorePages)
        XCTAssertEqual(view.newsItems.count, 1)
    }
    
    func testErrorHandling() async {
        mockNewsController.shouldThrowError = true
        
        let view = TestableNewsView(newsController: mockNewsController)
        
        await view.loadNews()
        
        XCTAssertTrue(view.newsItems.isEmpty)
        XCTAssertFalse(view.isLoading)
        XCTAssertNotNil(view.errorMessage)
        XCTAssertEqual(view.errorMessage, "Mock error")
    }
    
    func testNewsItemView() {
        let newsItem = NewsItem(title: "Test News", link: "https://test.com", img: "https://test.com/image.jpg", short_desc: "Test description")
        let view = NewsItemView(item: newsItem)
        
        let hostingController = UIHostingController(rootView: view)
        _ = hostingController.view
        
        XCTAssertNotNil(hostingController.view)
    }
}

// MARK: - NewsView Extensions

extension NewsView {
    static func loadNews(newsItems: inout [NewsItem], isLoading: inout Bool, errorMessage: inout String?, currentPage: Int, hasMorePages: inout Bool, newsController: NewsController) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let items = try await newsController.fetchNews(page: currentPage)
            newsItems = items
            hasMorePages = items.count == 5  // Assuming 5 items per page
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    static func loadMoreNews(newsItems: inout [NewsItem], isLoading: inout Bool, errorMessage: inout String?, currentPage: inout Int, hasMorePages: inout Bool, newsController: NewsController) async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        currentPage += 1
        
        do {
            let newItems = try await newsController.fetchNews(page: currentPage)
            newsItems.append(contentsOf: newItems)
            hasMorePages = newItems.count == 5  // Assuming 5 items per page
        } catch {
            errorMessage = error.localizedDescription
            currentPage -= 1  // Revert page increment on error
        }
        
        isLoading = false
    }
    
    static func refreshNews(newsItems: inout [NewsItem], isLoading: inout Bool, errorMessage: inout String?, currentPage: inout Int, hasMorePages: inout Bool, newsController: NewsController) async {
        currentPage = 1
        hasMorePages = true
        await loadNews(newsItems: &newsItems, isLoading: &isLoading, errorMessage: &errorMessage, currentPage: currentPage, hasMorePages: &hasMorePages, newsController: newsController)
    }
}
