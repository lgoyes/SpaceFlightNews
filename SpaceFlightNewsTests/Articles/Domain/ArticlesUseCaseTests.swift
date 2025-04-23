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
        var result = [Article]()
        
        for _ in 0..<2 {
            try await sut.execute()
            let partialResult = try sut.getResult()
            result.append(contentsOf: partialResult)
        }
        
        #expect(result.count == 20)
    }
}
