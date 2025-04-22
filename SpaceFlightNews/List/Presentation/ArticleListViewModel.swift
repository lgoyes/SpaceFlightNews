//
//  ArticleListViewModel.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import Combine

class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var searchQuery: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    private let articlesUseCase: any ArticlesUseCase
    
    init(articlesUseCase: any ArticlesUseCase) {
        self.articlesUseCase = articlesUseCase
    }

    func fetchArticles() {
        isLoading = true
        errorMessage = nil
        Task {
            await performSearch()
        }
    }
    
    func performSearch() async {
        do {
            try await articlesUseCase.execute()
        } catch {
            await set(errorMessage: "perform search error")
        }
    }
    
    @MainActor func updateArticles() {
        do {
            isLoading = false
            errorMessage = nil
            articles = try articlesUseCase.getResult()
        } catch {
            set(errorMessage: "some error")
        }
    }
    
    @MainActor func set(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
