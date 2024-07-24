//
//  NewsControllerTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
@testable import ApexLegendsStats

class TestableNewsController: NewsController {
    var mockAPIService: ApexAPIService

    init(mockAPIService: ApexAPIService) {
        self.mockAPIService = mockAPIService
        super.init()
    }

    var apexAPIService: ApexAPIService {
        return mockAPIService
    }
}

class NewsControllerTests: XCTestCase {
    var sut: TestableNewsController!
    var mockAPIService: MockApexAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockApexAPIService()
        sut = TestableNewsController(mockAPIService: mockAPIService)
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testFetchNewsSuccessFirstPage() async throws {
        // Given
        let mockNews = (1...10).map { NewsItem(title: "News \($0)", link: "link\($0)", img: "img\($0)", short_desc: "desc\($0)") }
        mockAPIService.mockNews = mockNews

        // When
        let result = try await sut.fetchNews(page: 1)

        // Then
        XCTAssertTrue(mockAPIService.fetchNewsCalled)
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result[0].title, "News 1")
        XCTAssertEqual(result[4].title, "News 5")
    }

    func testFetchNewsSuccessSecondPage() async throws {
        // Given
        let mockNews = (1...10).map { NewsItem(title: "News \($0)", link: "link\($0)", img: "img\($0)", short_desc: "desc\($0)") }
        mockAPIService.mockNews = mockNews

        // When
        let result = try await sut.fetchNews(page: 2)

        // Then
        XCTAssertTrue(mockAPIService.fetchNewsCalled)
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result[0].title, "News 6")
        XCTAssertEqual(result[4].title, "News 10")
    }

    func testFetchNewsLastPageWithFewerItems() async throws {
        // Given
        let mockNews = (1...7).map { NewsItem(title: "News \($0)", link: "link\($0)", img: "img\($0)", short_desc: "desc\($0)") }
        mockAPIService.mockNews = mockNews

        // When
        let result = try await sut.fetchNews(page: 2)

        // Then
        XCTAssertTrue(mockAPIService.fetchNewsCalled)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].title, "News 6")
        XCTAssertEqual(result[1].title, "News 7")
    }

    func testFetchNewsEmptyResult() async throws {
        // Given
        mockAPIService.mockNews = []

        // When
        let result = try await sut.fetchNews(page: 1)

        // Then
        XCTAssertTrue(mockAPIService.fetchNewsCalled)
        XCTAssertTrue(result.isEmpty)
    }

    func testFetchNewsPageBeyondAvailable() async throws {
        // Given
        let mockNews = (1...5).map { NewsItem(title: "News \($0)", link: "link\($0)", img: "img\($0)", short_desc: "desc\($0)") }
        mockAPIService.mockNews = mockNews

        // When
        let result = try await sut.fetchNews(page: 3)

        // Then
        XCTAssertTrue(mockAPIService.fetchNewsCalled)
        XCTAssertTrue(result.isEmpty)
    }

    func testFetchNewsThrowsError() async {
        // Given
        mockAPIService.mockNews = nil

        // When/Then
        do {
            _ = try await sut.fetchNews(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(mockAPIService.fetchNewsCalled)
            XCTAssertTrue(error is NSError)
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "MockApexAPIService")
            XCTAssertEqual(nsError.code, 0)
            XCTAssertEqual(nsError.localizedDescription, "Mock news data is nil")
        }
    }
}
