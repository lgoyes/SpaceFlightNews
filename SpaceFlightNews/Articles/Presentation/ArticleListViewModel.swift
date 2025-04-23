//
//  ArticleListViewModel.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import Combine

enum ArticleListState {
    case idle, downloadingFirstPage, loadingNextPage, data
}

@MainActor
class ArticleListViewModel: ObservableObject {
    private enum Constant {
        static let downloadErrorMessage = "Error en la descarga.\nPor favor vuelva a intentar en unos instantes.\n Nuestro API es muy malito :D"
    }
    @Published var articles: [Article] = []
    @Published var searchQuery: String = ""
    @Published var errorMessage: String? = nil
    @Published var state: ArticleListState = .idle
    
    private let articlesUseCase: any ArticlesUseCase
    
    init(articlesUseCase: any ArticlesUseCase) {
        self.articlesUseCase = articlesUseCase
    }
    
    func clearSearchQuery() {
        searchQuery = ""
        reload()
    }
    
    func loadMoreItems() {
        if state == .loadingNextPage || state == .downloadingFirstPage { return }
        state = .loadingNextPage
        Task {
            await fetchArticles()
        }
    }
    
    func reload() {
        state = .downloadingFirstPage
        articlesUseCase.reset()
        Task {
            await fetchArticles()
        }
    }

    func fetchArticles() async {
        errorMessage = nil
        await performSearch()
    }
    
    nonisolated func performSearch() async {
        await articlesUseCase.set(searchQuery: searchQuery)
        try? await articlesUseCase.execute()
        await updateArticles()
    }
    
    func updateArticles() {
        state = .data
        errorMessage = nil
        do {
            articles = try articlesUseCase.getResult()
        } catch {
            errorMessage = Constant.downloadErrorMessage
        }
    }
}
