//
//  DefaultArticlesUseCaseTests.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Testing
import Foundation
@testable import SpaceFlightNews

final class ArticlesListRepositoryStub: ArticlesListRepository {
    var result: [Article] = []
    var error: ArticlesListRepositoryError?
    var offset: Int!
    
    func listArticles(searchQuery: String, offset: Int, limit: Int) async throws(ArticlesListRepositoryError) -> [Article] {
        self.offset = offset
        if let error = error {
            throw error
        }
        return result
    }
}

final class DefaultArticlesUseCaseTests {
    
    private let sut: DefaultArticlesUseCase
    private let repository: ArticlesListRepositoryStub
    
    init() {
        repository = .init()
        sut = DefaultArticlesUseCase(repository: repository)
    }
    
    @Test("GIVEN a successful response, WHEN execute, THEN it should return the articles sorted by published date in descending order")
    func returnsSortedArticles() async throws {
        GIVEN_someUnsortedArticles()
        try await WHEN_execute()
        try THEN_itShouldReturnArticlesSortedByPublishedDate()
    }
    
    func GIVEN_someUnsortedArticles() {
        let newer = DummyArticleFactory.create(id: 2, publishedAt: Date())
        let older = DummyArticleFactory.create(id: 1, publishedAt: Date(timeIntervalSinceNow: -10000))
        repository.result = [older, newer]
    }
    
    func WHEN_execute() async throws {
        try await sut.execute()
    }
    
    func THEN_itShouldReturnArticlesSortedByPublishedDate() throws {
        let results = try sut.getResult()
        #expect(results[0].publishedAt > results[1].publishedAt)
    }
    
    @Test("GIVEN a network error, WHEN execute, THEN it should throw an ArticlesUseCaseError.networkError")
    func handlesNetworkError() async {
        repository.error = .networkError
        await #expect(throws: ArticlesUseCaseError.networkError) {
            try await self.sut.execute()
        }
    }
    
    @Test("GIVEN an existing offset, WHEN execute, THEN it should increase the offset accordingly")
    func increasesOffsetCorrectly() async throws {
        GIVEN_initialOffset(5)
        GIVEN_someArticles(count: 3)
        try await WHEN_execute()
        try await THEN_offsetShouldBe(expected: 8)
    }
    
    func GIVEN_initialOffset(_ value: Int) {
        sut.set(offset: value)
    }
    
    func GIVEN_someArticles(count: Int) {
        repository.result = (0..<count).map {
            DummyArticleFactory.create(id: $0, publishedAt: Date(timeIntervalSinceNow: TimeInterval(-$0)))
        }
    }
    
    func THEN_offsetShouldBe(expected: Int) async throws {
        try await WHEN_execute()
        #expect(repository.offset == expected)
    }
    
    @Test("GIVEN articles fetched, WHEN execute again, THEN it should merge and remove duplicated articles")
    func mergesAndDeduplicatesArticles() async throws {
        let article = DummyArticleFactory.create(id: 1)
        repository.result = [article]
        try await sut.execute()
        try await sut.execute()
        
        let results = try sut.getResult()
        #expect(results.count == 1)
    }
    
    @Test("GIVEN ongoing fetch, WHEN execute again, THEN it should skip the fetch")
    func skipsFetchWhenAlreadyFetching() async throws {
        GIVEN_article()
        try await sut.execute()
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                try await self.sut.execute()
            }
            group.addTask {
                try await self.sut.execute()
            }
            try await group.waitForAll()
        }
        
        let results = try sut.getResult()
        #expect(results.count == 1)
    }
    
    func GIVEN_article() {
        repository.result = [DummyArticleFactory.create()]
    }
    
    @Test("GIVEN articles fetched, WHEN reset, THEN it should clear the internal state")
    func clearsStateOnReset() async throws {
        GIVEN_article()
        try await sut.execute()
        sut.reset()
        try await sut.execute()
        
        let results = try sut.getResult()
        #expect(results.count == 1)
    }
}
