//
//  ArticlesRepositoryFactoryTests.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Testing
@testable import SpaceFlightNews

final class ArticlesRepositoryFactoryTests {
    
    private let sut = ArticlesRepositoryFactory()
    private var result: ArticlesListRepository!

    @Test("WHEN create, THEN it should create some valid repository")
    func map() {
        WHEN_create()
        THEN_itShouldCreateSomeValidRepository()
    }
    
    func WHEN_create() {
        result = sut.create()
    }
    
    func THEN_itShouldCreateSomeValidRepository() {
        #expect(result is DefaultArticlesListRepository)
    }
}
