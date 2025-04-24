//
//  ArticlesUseCaseFactoryTests.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Testing
@testable import SpaceFlightNews

final class ArticlesUseCaseFactoryTests {
    
    private let sut = ArticlesUseCaseFactory()
    private var result: (any ArticlesUseCase)!

    @Test("WHEN create, THEN it should create some valid use case")
    func map() {
        WHEN_create()
        THEN_itShouldCreateSomeValidRepository()
    }
    
    func WHEN_create() {
        result = sut.create()
    }
    
    func THEN_itShouldCreateSomeValidRepository() {
        #expect(result is DefaultArticlesUseCase)
    }
}
