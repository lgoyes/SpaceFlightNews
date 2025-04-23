//
//  ArticleListViewModel.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import Combine

enum ArticleListState {
    case loadingNextPage, data
}

@MainActor
class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var searchQuery: String = ""
    @Published var errorMessage: String? = nil
    @Published var state: ArticleListState = .data
    
    private let articlesUseCase: any ArticlesUseCase
    
    init(articlesUseCase: any ArticlesUseCase) {
        self.articlesUseCase = articlesUseCase
    }

    func fetchArticles() async {
        state = .loadingNextPage
        errorMessage = nil
        await performSearch()
    }
    
    nonisolated func performSearch() async {
        do {
            try await articlesUseCase.execute()
        } catch {
            debugPrint(error.localizedDescription)
        }
        await updateArticles()
    }
    
    func updateArticles() {
        do {
            state = .data
            errorMessage = nil
            articles = try articlesUseCase.getResult()
        } catch {
            set(errorMessage: "Error en la descarga")
        }
    }
    
    func set(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
