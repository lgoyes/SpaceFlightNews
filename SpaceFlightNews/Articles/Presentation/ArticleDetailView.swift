//
//  ArticleDetailView.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import SwiftUI

struct PublicationDateFormatter {
    private let formatter = DateFormatter()
    let article: Article
    func getPublicationDate() -> String {
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateStyle = .long
        return formatter.string(from: article.publishedAt)
    }
}

struct ArticleDetailView: View {
    private enum Constant {
        static let verticalSpacing: CGFloat = 16
    }
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constant.verticalSpacing) {
                buildImage()
                buildTitle()
                buildPublicationDate()
                buildSummary()
                buildArticleLink()
            }
            .padding()
        }
        .navigationTitle("key_details")
    }
    
    @ViewBuilder
    private func buildImage() -> some View {
        if let url = article.imageUrl {
            AsyncImage(url: url) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        }
    }
    
    private func buildTitle() -> some View {
        Text(article.title)
            .font(.title)
            .bold()
    }
    
    private func buildPublicationDate() -> some View {
        Text(PublicationDateFormatter(article: article).getPublicationDate())
            .font(.subheadline)
            .foregroundColor(.gray)
    }
    
    private func buildSummary() -> some View {
        Text(article.summary)
    }
    
    private func buildArticleLink() -> some View {
        Link("key_read_more", destination: article.url)
            .foregroundColor(.blue)
    }
}

#Preview {
    NavigationView {
        ArticleDetailView(article: Article(id: 1, title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", imageUrl: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjUTDorEQ_gvNWZBR1xa6nA-kIfKaWplcV_Q&s")!, publishedAt: ISO8601DateFormatter().date(from: "2025-04-23T15:48:16Z")!, url: URL(string: "www.lipsum.com")!))
    }
}
