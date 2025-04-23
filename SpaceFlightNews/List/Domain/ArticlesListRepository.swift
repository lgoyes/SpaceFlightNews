//
//  ArticlesListRepository.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

enum ArticlesListRepositoryError: Swift.Error {
    case networkError
}

protocol ArticlesListRepository {
    func listArticles(searchQuery: String, offset: Int, limit: Int) async throws(ArticlesListRepositoryError)-> [Article]
}
