//
//  DefaultArticlesListRepositoryTests.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Testing
@testable import SpaceFlightNews

fileprivate final class APIClientStub: RESTAPIFetchable {
    var response: Decodable!
    var error: RESTAPIFetchableError?
    
    func fetchData<T>(from urlString: String) async throws(RESTAPIFetchableError) -> T where T : Decodable {
        if let error {
            throw error
        }
        return response as! T
    }
}

final class DefaultArticlesListRepositoryTests {
    
    private var sut: DefaultArticlesListRepository!
    private let clientStub: APIClientStub
    private let articleMapper: APIArticleMapper
    private var result: [Article]!
    private var delayed_listArticles_closure: (() async throws -> Void)!
    
    init() {
        clientStub = APIClientStub()
        articleMapper = APIArticleMapper()
        sut = DefaultArticlesListRepository(apiClient: clientStub, baseURL: "", articleMapper: articleMapper)
    }
    
    @Test("GIVEN some valid response from APIClient, WHEN listArticles, THEN it should return some articles")
    func listArticles() async throws {
        GIVEN_someValidResponseFromAPIClient()
        try await WHEN_listArticles()
        THEN_itShouldReturnSomeArticles()
    }
    
    func GIVEN_someValidResponseFromAPIClient() {
        clientStub.response = APIArticleResponse(count: 10, next: "any-next", previous: nil, results: [
            DummyAPIArticleFactory.create()
        ])
    }
    
    func WHEN_listArticles() async throws {
        result = try await sut.listArticles(searchQuery: "some-query", offset: 0, limit: 10)
    }
    
    func THEN_itShouldReturnSomeArticles() {
        #expect(result[0] == DummyArticleFactory.create())
    }
    
    @Test("GIVEN some invalid response from APIClient, WHEN listArticles, THEN it should throw an error")
    func errorFromAPIClient() async throws {
        GIVEN_someInvalidResponseFromAPIClient()
        WHEN_listArticles_delayed()
        await THEN_itShouldThrowAnError()
    }
    
    func GIVEN_someInvalidResponseFromAPIClient() {
        clientStub.error = RESTAPIFetchableError.badURL
    }
    
    func WHEN_listArticles_delayed() {
        delayed_listArticles_closure = { [unowned self] in
            self.result = try await self.sut.listArticles(searchQuery: "any-query", offset: 0, limit: 10)
        }
    }
    
    func THEN_itShouldThrowAnError() async {
        await #expect(throws: ArticlesListRepositoryError.networkError) {
            try await self.delayed_listArticles_closure()
        }
    }
}
