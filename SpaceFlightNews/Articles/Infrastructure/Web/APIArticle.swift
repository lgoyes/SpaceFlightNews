//
//  APIArticle.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

struct APIArticleResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [APIArticle]
}

struct APIArticle: Decodable {
    let id: Int
    let title: String
    let authors: [APIAuthor]
    let url: String
    let imageURL: String?
    let summary: String
    let publishedAt: String
    let updatedAt: String
    let featured: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, authors, url, imageURL = "image_url", summary, publishedAt = "published_at", updatedAt = "updated_at", featured
    }
}

struct APIAuthor: Decodable {
    let name: String
    let socials: APISocial?
}

struct APISocial: Decodable {
    let x: String?
    let youtube, instagram: String?
    let linkedin, mastodon: String?
    let bluesky: String?
}
