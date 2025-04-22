//
//  ArticlesUseCase.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

enum ArticlesUseCaseError: Swift.Error {
    
}

protocol ArticlesUseCase: UseCase where Output == [Article], ErrorType == ArticlesUseCaseError {
    
}

class DefaultArticlesUseCase: ArticlesUseCase {
    private(set) var error: ArticlesUseCaseError?
    private(set) var result: Array<Article>?
    
    private let apiClient: APIClient
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func execute() async throws(ArticlesUseCaseError) {
        
    }
}
