//
//  ArticleListView+PreviewDependencies.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import SwiftUI

#if DEBUG
class DummyArticlesUseCase: ArticlesUseCase {
    
    var error: ArticlesUseCaseError?
    var result: Array<Article>?
    
    func execute() async throws(ArticlesUseCaseError) {
        let date = ISO8601DateFormatter().date(from: "2025-04-23T15:48:16Z")!
        result = [
            Article(id: 1, title: "Lorem ipsum", summary: "Lorem ipsum Lorem ipsum Lorem ipsum", imageUrl: nil, publishedAt: date, url: URL(string: "https://www.google.com")!),
            Article(id: 2, title: "Lorem ipsum", summary: "Lorem ipsum Lorem ipsum Lorem ipsum", imageUrl: nil, publishedAt: date, url: URL(string: "https://www.google.com")!),
            Article(id: 3, title: "Lorem ipsum", summary: "Lorem ipsum Lorem ipsum Lorem ipsum", imageUrl: nil, publishedAt: date, url: URL(string: "https://www.google.com")!)
        ]
    }
    
    func set(searchQuery: String) {
        
    }
    
    func set(offset: Int) {
        
    }
    
    func set(limit: Int) {
        
    }
}
#endif
