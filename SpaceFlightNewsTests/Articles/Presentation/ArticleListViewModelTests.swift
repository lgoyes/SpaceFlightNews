//
//  ArticleListViewModelTests.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Testing
import Combine
@testable import SpaceFlightNews

fileprivate class ArticlesUseCaseStub: ArticlesUseCase {
    var error: ArticlesUseCaseError?
    var result: [Article]? = []
    var searchQuery: String = ""
    var shouldThrowError = false
    var didReset = false
    var executeCalled = false
    
    func execute() async throws(ArticlesUseCaseError) {
        executeCalled = true
        if let error {
            throw error
        }
    }
    
    func getResult() throws -> [Article] {
        if let error {
            throw error
        }
        return result!
    }
    
    func reset() {
        didReset = true
    }
    
    func set(searchQuery: String) {
        self.searchQuery = searchQuery
    }
    
    func set(offset: Int) { }
    
    func set(limit: Int) { }
}

final class TestingArticleListViewModel: ArticleListViewModel {
    var fetchArticlesDone: () -> Void = {}
    override func fetchArticles() async {
        await super.fetchArticles()
        fetchArticlesDone()
    }
}

@MainActor
final class ArticleListViewModelTests {
    private var sut: TestingArticleListViewModel!
    private var useCase: ArticlesUseCaseStub!
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        useCase = ArticlesUseCaseStub()
        sut = TestingArticleListViewModel(articlesUseCase: useCase)
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    @Test("GIVEN a successful fetch, WHEN reload is called, THEN it should reset, fetch and update state to data")
    func reload_resetsAndFetchesArticles_successfullyUpdatesState() async {
        GIVEN_successfulArticleFetch()
        await WHEN_reload()
        THEN_shouldResetUseCase()
        THEN_shouldHaveFetchedArticles()
        THEN_stateShouldBe(.data)
        THEN_errorMessageShouldBeNil()
        THEN_articleCountShouldBe(1)
    }
    
    func GIVEN_successfulArticleFetch() {
        let article = DummyArticleFactory.create(id: 1, title: "Test")
        useCase.result = [article]
    }
    
    @Test("GIVEN an error occurs, WHEN reload is called, THEN it should set the error message")
    func reload_withError_setsErrorMessage() async {
        GIVEN_errorOnFetch()
        await WHEN_reload()
        THEN_shouldResetUseCase()
        THEN_shouldHaveFetchedArticles()
        THEN_stateShouldBe(.data)
        THEN_errorMessageShouldBe("Error en la descarga.\nPor favor vuelva a intentar en unos instantes.\n Nuestro API es muy malito :D")
        THEN_articleCountShouldBe(0)
    }
    
    func GIVEN_errorOnFetch() {
        useCase.error = .networkError
    }
    
    func WHEN_reload() async {
        await withCheckedContinuation { continuation in
            sut.fetchArticlesDone = {
                continuation.resume()
            }
            sut.reload()
        }
    }
    
    func THEN_shouldResetUseCase() {
        #expect(useCase.didReset == true)
    }
    
    func THEN_errorMessageShouldBe(_ expected: String?) {
        #expect(sut.errorMessage == expected)
    }
    
    @Test("GIVEN idle state and valid response, WHEN loadMoreItems is called, THEN it should fetch and update the state to data")
    func loadMoreItems_whenIdle_fetchesArticles_andUpdatesState() async {
        GIVEN_idleStateWithArticles()
        await WHEN_loadMoreItems()
        THEN_shouldHaveFetchedArticles()
        THEN_articleCountShouldBe(1)
        THEN_stateShouldBe(.data)
        THEN_errorMessageShouldBeNil()
    }
    
    func GIVEN_idleStateWithArticles() {
        let article = DummyArticleFactory.create(id: 2, title: "Another")
        useCase.result = [article]
        sut.state = .idle
    }

    func WHEN_loadMoreItems() async {
        await withCheckedContinuation { continuation in
            sut.fetchArticlesDone = {
                continuation.resume()
            }
            sut.loadMoreItems()
        }
    }
    
    func THEN_shouldHaveFetchedArticles() {
        #expect(useCase.executeCalled == true)
    }
    
    func THEN_articleCountShouldBe(_ expected: Int) {
        #expect(sut.articles.count == expected)
    }
    
    func THEN_stateShouldBe(_ expected: ArticleListState) {
        #expect(sut.state == expected)
    }
    
    func THEN_errorMessageShouldBeNil() {
        #expect(sut.errorMessage == nil)
    }
    
    @Test("GIVEN a search query, WHEN fetchArticles is called, THEN the query should propagate to useCase")
    func fetchArticles_withSearchQuery_propagatesToUseCase() async {
        GIVEN_searchQuery("Moon")
        await WHEN_fetchArticles()
        THEN_searchQueryShouldBe("Moon")
    }
    
    func GIVEN_searchQuery(_ query: String) {
        sut.searchQuery = query
    }
    
    func WHEN_fetchArticles() async {
        await sut.fetchArticles()
    }
    
    func THEN_searchQueryShouldBe(_ expected: String) {
        #expect(useCase.searchQuery == expected)
    }
}
