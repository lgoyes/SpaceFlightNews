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
                
                List {
                    if let error = viewModel.errorMessage {
                        Text("key_error: \(error)").foregroundColor(.red).padding()
                    } else {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(destination: ArticleDetailView(article: article)) {
                                ArticleListRow(article: article)
                                    .onAppear {
                                        viewModel.loadMoreIfNeeded(item: article)
                                    }
                            }
                        }
                        
                        if viewModel.state == .loadingNextPage {
                            ProgressView()
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .searchable(text: $viewModel.searchQuery, prompt: "key_search")
                .refreshable {
                    viewModel.reload()
                }
            }
            .onAppear {
                viewModel.reload()
            }
        }
        
        .navigationTitle("key_space_news")
    }
}

#Preview {
    ArticleListView(viewModel: ArticleListViewModel(articlesUseCase: DummyArticlesUseCase()))
}
