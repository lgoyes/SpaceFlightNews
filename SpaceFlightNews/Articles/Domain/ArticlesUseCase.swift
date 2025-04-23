//
//  ArticlesUseCase.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

enum ArticlesUseCaseError: Swift.Error {
    case networkError
}

protocol ArticlesUseCase: UseCase where Output == [Article], ErrorType == ArticlesUseCaseError {
    func set(searchQuery: String)
    func set(offset: Int)
    func set(limit: Int)
    func reset()
}

class DefaultArticlesUseCase: ArticlesUseCase {
    
    private(set) var error: ArticlesUseCaseError?
    private(set) var result: Array<Article>? = []
    
    private var searchQuery: String = ""
    private var offset: Int = 0
    private var limit: Int = 10
    private var isFetchingMore = false
    
    private let repository: ArticlesListRepository
    init(repository: ArticlesListRepository) {
        self.repository = repository
    }

    func execute() async throws(ArticlesUseCaseError) {
        if isFetchingMore {
            return
        }
        
        isFetchingMore = true
        
        do {
            let response = try await repository.listArticles(searchQuery: searchQuery, offset: offset, limit: limit)
            handle(response: response)
        } catch {
            self.error = .networkError
            throw self.error!
        }
    }
    
    func getResult() throws(ArticlesUseCaseError) -> Array<Article> {
        defer { isFetchingMore = false }
        if let error = self.error {
            throw error
        }
        return self.result!
    }
    
    private func handle(response: [Article]) {
        offset += response.count
        result?.append(contentsOf: response)
    }
    
    func reset() {
        isFetchingMore = false
        offset = 0
        self.result = [Article]()
    }
    
    func set(searchQuery: String) {
        self.searchQuery = searchQuery
    }
    
    func set(offset: Int) {
        self.offset = offset
    }
    
    func set(limit: Int) {
        self.limit = limit
    }
}
