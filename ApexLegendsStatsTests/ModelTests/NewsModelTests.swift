//
//  NewsModelTests.swift
//  ApexLegendsStatsTests
//
//  Created by Younis on 7/24/24.
//

import XCTest
@testable import ApexLegendsStats

class NewsModelTests: XCTestCase {

    func testNewsItemDecoding() throws {
        let json = """
        {
            "title": "New Legend Revealed!",
            "link": "https://www.ea.com/games/apex-legends/news/new-legend",
            "img": "https://media.contentapi.ea.com/content/dam/apex-legends/images/2024/07/new-legend-reveal.jpg",
            "short_desc": "Get ready for the newest addition to the Apex Games!"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let newsItem = try decoder.decode(NewsItem.self, from: json)

        XCTAssertEqual(newsItem.title, "New Legend Revealed!")
        XCTAssertEqual(newsItem.link, "https://www.ea.com/games/apex-legends/news/new-legend")
        XCTAssertEqual(newsItem.img, "https://media.contentapi.ea.com/content/dam/apex-legends/images/2024/07/new-legend-reveal.jpg")
        XCTAssertEqual(newsItem.short_desc, "Get ready for the newest addition to the Apex Games!")
        XCTAssertEqual(newsItem.id, newsItem.link)
    }

    func testInvalidNewsItemDecoding() {
        let invalidJson = "{ \"invalid\": \"data\" }".data(using: .utf8)!
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(NewsItem.self, from: invalidJson)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testMultipleNewsItemsDecoding() throws {
        let json = """
        [
            {
                "title": "New Legend Revealed!",
                "link": "https://www.ea.com/games/apex-legends/news/new-legend",
                "img": "https://media.contentapi.ea.com/content/dam/apex-legends/images/2024/07/new-legend-reveal.jpg",
                "short_desc": "Get ready for the newest addition to the Apex Games!"
            },
            {
                "title": "Season 19 Battle Pass",
                "link": "https://www.ea.com/games/apex-legends/news/season-19-battle-pass",
                "img": "https://media.contentapi.ea.com/content/dam/apex-legends/images/2024/07/season-19-battle-pass.jpg",
                "short_desc": "Check out the rewards for the new Battle Pass!"
            }
        ]
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let newsItems = try decoder.decode([NewsItem].self, from: json)

        XCTAssertEqual(newsItems.count, 2)
        XCTAssertEqual(newsItems[0].title, "New Legend Revealed!")
        XCTAssertEqual(newsItems[1].title, "Season 19 Battle Pass")
        XCTAssertEqual(newsItems[0].id, "https://www.ea.com/games/apex-legends/news/new-legend")
        XCTAssertEqual(newsItems[1].id, "https://www.ea.com/games/apex-legends/news/season-19-battle-pass")
    }
}
