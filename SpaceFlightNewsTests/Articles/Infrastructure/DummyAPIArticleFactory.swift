//
//  DummyAPIArticleFactory.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

@testable import SpaceFlightNews

enum DummyAPIArticleConstant {
    static let id = 1
    static let title = "some-title"
    static let url = "some-url"
    static let imageURL = "some-image-url"
    static let summary = "some-summary"
    static let publishedAt = "2025-04-23T22:03:00Z"
    static let updatedAt = "2025-04-23T22:03:00Z"
    static let featured = false
}

class DummyAPIArticleFactory {
    static func create(id: Int = DummyAPIArticleConstant.id, title: String = DummyAPIArticleConstant.title, authors: [APIAuthor] = [], url: String = DummyAPIArticleConstant.url, imageURL: String? = DummyAPIArticleConstant.imageURL, summary: String = DummyAPIArticleConstant.summary, publishedAt: String = DummyAPIArticleConstant.publishedAt, updatedAt: String = DummyAPIArticleConstant.updatedAt, featured: Bool = DummyAPIArticleConstant.featured) -> APIArticle {
        .init(id: id, title: title, authors: authors, url: url, imageURL: imageURL, summary: summary, publishedAt: publishedAt, updatedAt: updatedAt, featured: featured)
    }
}
