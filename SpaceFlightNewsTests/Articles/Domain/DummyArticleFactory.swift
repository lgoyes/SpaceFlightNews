//
//  DummyArticleFactory.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Foundation
@testable import SpaceFlightNews

enum DummyArticleConstant {
    static let id = 1
    static let title = "some-title"
    static let url = "some-url"
    static let imageURL = "some-image-url"
    static let summary = "some-summary"
    static let publishedAt = ISO8601DateFormatter().date(from: "2025-04-23T22:03:00Z")!
}

class DummyArticleFactory {
    static func create(id: Int = DummyArticleConstant.id, title: String = DummyArticleConstant.title, url: String = DummyArticleConstant.url, imageURL: String? = DummyArticleConstant.imageURL, summary: String = DummyArticleConstant.summary, publishedAt: Date = DummyArticleConstant.publishedAt) -> Article {
        .init(id: id, title: title, summary: summary, imageUrl: imageURL != nil ? URL(string: imageURL!) : nil, publishedAt: publishedAt, url: URL(string: url)!)
    }
}
