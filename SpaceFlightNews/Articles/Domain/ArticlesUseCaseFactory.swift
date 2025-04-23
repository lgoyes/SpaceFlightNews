//
//  ArticlesUseCaseFactory.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

class ArticlesUseCaseFactory {
    private var logger: Logger?
    
    init(logger: Logger? = nil) {
        self.logger = logger
    }
    
    func create() -> any ArticlesUseCase {
        let repository = ArticlesRepositoryFactory(logger: logger).create()
        let result = DefaultArticlesUseCase(repository: repository)
        return result
    }
}
