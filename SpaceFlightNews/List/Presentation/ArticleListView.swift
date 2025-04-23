//
//  Untitled.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import SwiftUI

struct ArticleListRow: View {
    var article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .bold()
            Text(article.formattedPublishedDate)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(article.summary)
                .font(.subheadline)
                .lineLimit(2)
        }
    }
}

struct ArticleListView: View {
    @StateObject var viewModel: ArticleListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let error = viewModel.errorMessage {
                    Text("key_error: \(error)").foregroundColor(.red).padding()
                } else {
                    List {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(destination: ArticleDetailView(article: article)) {
                                ArticleListRow(article: article)
                            }
                        }
                        
                        ProgressView()
                            .onAppear {
                                if viewModel.state == .data {
                                    Task {
                                        await viewModel.fetchArticles()
                                    }
                                }
                            }
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .searchable(text: $viewModel.searchQuery, prompt: "key_search")
                }
            }
            .navigationTitle("key_space_news")
        }
    }
}

#Preview {
    ArticleListView(viewModel: ArticleListViewModel(articlesUseCase: DummyArticlesUseCase()))
}
