//
//  ArticleDetailView.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import SwiftUI

struct ArticleDetailView: View {
    private enum Constant {
        static let verticalSpacing: CGFloat = 16
    }
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constant.verticalSpacing) {
                if let url = article.imageUrl {
                    AsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }
                Text(article.title)
                    .font(.title)
                    .bold()
                Text(article.formattedPublishedDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(article.summary)
                Link("key_read_more", destination: article.url)
                    .foregroundColor(.blue)
                
            }
            .padding()
        }
        .navigationTitle("key_details")
    }
}

#Preview {
    NavigationView {
        ArticleDetailView(article: Article(id: 1, title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", imageUrl: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjUTDorEQ_gvNWZBR1xa6nA-kIfKaWplcV_Q&s")!, publishedAt: ISO8601DateFormatter().date(from: "2025-04-23T15:48:16Z")!, url: URL(string: "www.lipsum.com")!))
    }
}
