//
//  APIArticleMapperTests.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Testing
import Foundation
@testable import SpaceFlightNews

struct APIArticleMapperTests {
    let sut = APIArticleMapper()
    
    @Test
    func map() throws {
        let someAPIArticle = DummyAPIArticleFactory.create()
        let result = try sut.map(someAPIArticle)
        #expect(result.id == someAPIArticle.id)
        #expect(result.title == someAPIArticle.title)
        #expect(result.summary == someAPIArticle.summary)
        #expect(result.imageUrl == URL(string:someAPIArticle.imageURL!))
        #expect(result.publishedAt == ISO8601DateFormatter().date(from: someAPIArticle.publishedAt)!)
        #expect(result.url == URL(string: someAPIArticle.url)!)
    }
    
    @Test
    func mapWithInvalidDate() {
        let someAPIArticle = DummyAPIArticleFactory.create(publishedAt: "invalid-date")
        #expect(throws: APIArticleMapperError.invalidDateFormat, performing: {
            try sut.map(someAPIArticle)
        })
    }
    
    @Test
    func mapWithURL() {
        let someAPIArticle = DummyAPIArticleFactory.create(url: "")
        #expect(throws: APIArticleMapperError.invalidURLFormat, performing: {
            try sut.map(someAPIArticle)
        })
    }
}
