//
//  Article.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import Foundation

struct Article: Identifiable {
    let id: Int
    let title: String
    let summary: String
    let imageUrl: URL?
    let publishedAt: Date
    let url: URL
    
    var formattedPublishedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateStyle = .long
        return formatter.string(from: publishedAt)
    }
}
