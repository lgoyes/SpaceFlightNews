//
//  ArticleListFactory.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

class ArticleListFactory {
    @MainActor static func create() -> ArticleListView {
        let useCase = ArticlesUseCaseFactory().create()
        let viewModel = ArticleListViewModel(articlesUseCase: useCase)
        return ArticleListView(viewModel: viewModel)
    }
}
