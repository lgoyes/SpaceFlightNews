//
//  DefaultArticlesListRepository.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Foundation

class DefaultArticlesListRepository: ArticlesListRepository {
    private var apiClient: RESTAPIFetchable
    private let baseURL: String
    private let articleMapper: APIArticleMapper
    
    init(apiClient: RESTAPIFetchable, baseURL: String, articleMapper: APIArticleMapper) {
        self.apiClient = apiClient
        self.baseURL = baseURL
        self.articleMapper = articleMapper
    }
    
    func listArticles(searchQuery: String, offset: Int, limit: Int) async throws(ArticlesListRepositoryError) -> [Article] {
        do {
            let url = try buildURL(searchQuery: searchQuery, offset: offset, limit: limit)
            let response: APIArticleResponse = try await apiClient.fetchData(from: url)
            return try response.results.map { try articleMapper.map($0) }
        } catch {
            throw .networkError
        }
    }
    
    private func buildURL(searchQuery: String, offset: Int, limit: Int) throws(ArticlesListRepositoryError) -> String {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw .networkError
        }
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        if !searchQuery.isEmpty {
            queryItems.append(URLQueryItem(name: "title_contains", value: searchQuery))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!.absoluteString
    }
}
