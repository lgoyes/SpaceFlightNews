//
//  Article.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import Foundation

struct Article: Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let summary: String
    let imageUrl: URL?
    let publishedAt: Date
    let url: URL
}
