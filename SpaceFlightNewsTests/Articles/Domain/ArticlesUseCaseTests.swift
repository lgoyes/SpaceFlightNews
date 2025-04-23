//
//  ArticlesUseCaseTests.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Testing
@testable import SpaceFlightNews

final class ArticlesUseCaseTests {
    
    @Test
    func repeatingCalls() async throws {
        let sut = ArticlesUseCaseFactory().create()
        
        for _ in 0..<2 {
            try await sut.execute()
        }
        
        let result = try sut.getResult()
        #expect(result.count == 20)
    }
}
