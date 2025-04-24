//
//  SettingsRetrieverFactoryTests.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Testing
@testable import SpaceFlightNews

final class SettingsRetrieverFactoryTests {
    
    private let sut = SettingsRetrieverFactory()
    private var result: SettingsRetrieverProtocol!

    @Test("WHEN create, THEN it should create some valid settings retriever")
    func map() {
        WHEN_create()
        THEN_itShouldCreateSomeValidSettingsRetriever()
    }
    
    func WHEN_create() {
        result = sut.create()
    }
    
    func THEN_itShouldCreateSomeValidSettingsRetriever() {
        #expect(result is SettingsRetriever)
    }
}
