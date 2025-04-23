//
//  APIMappers.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Foundation

enum APIArticleMapperError: Swift.Error {
    case invalidDateFormat, invalidURLFormat
}

protocol APIArticleMapperProtocol {
    func map(_ article: APIArticle) throws(APIArticleMapperError) -> Article
}

class APIArticleMapper: APIArticleMapperProtocol {
    let dateFormatter = ISO8601DateFormatter()
    
    func map(_ article: APIArticle) throws(APIArticleMapperError) -> Article {
        guard let publishedAt = dateFormatter.date(from: article.publishedAt) else {
            throw .invalidDateFormat
        }
        guard let url = URL(string: article.url) else {
            throw .invalidURLFormat
        }
        return .init(id: article.id, title: article.title, summary: article.summary, imageUrl: (article.imageURL != nil) ? URL(string: article.imageURL!) : nil, publishedAt: publishedAt, url: url)
    }
}
