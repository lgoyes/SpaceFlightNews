//
//  ArticleListViewModel.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import Combine

enum ArticleListState {
    case idle, loadingNextPage, data
}

@MainActor
class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var searchQuery: String = ""
    @Published var errorMessage: String? = nil
    @Published var state: ArticleListState = .idle
    
    private let articlesUseCase: any ArticlesUseCase
    
    init(articlesUseCase: any ArticlesUseCase) {
        self.articlesUseCase = articlesUseCase
    }
    
    func loadMoreIfNeeded(item: Article?) {
        if let item = item, item.id != articles.last?.id { return }
        if state == .loadingNextPage { return }
        Task {
            await fetchArticles()
        }
    }
    
    func reload() {
        articlesUseCase.reset()
        Task {
            await fetchArticles()
        }
    }

    func fetchArticles() async {
        state = .loadingNextPage
        errorMessage = nil
        await performSearch()
    }
    
    nonisolated func performSearch() async {
        try? await articlesUseCase.execute()
        await updateArticles()
    }
    
    func updateArticles() {
        state = .data
        errorMessage = nil
        do {
            articles = try articlesUseCase.getResult()
        } catch {
            set(errorMessage: "Error en la descarga")
        }
    }
    
    func set(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
