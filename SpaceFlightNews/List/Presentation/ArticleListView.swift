//
//  Untitled.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import SwiftUI

struct ArticleListView: View {
    @StateObject var viewModel: ArticleListViewModel

    var body: some View {
        NavigationView {
            VStack {
                TextField("key_search", text: $viewModel.searchQuery, onCommit: {
                    viewModel.fetchArticles()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text("key_error: \(error)").foregroundColor(.red).padding()
                } else {
                    List(viewModel.articles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            VStack(alignment: .leading) {
                                Text(article.title).bold()
                                Text(article.summary).font(.subheadline).lineLimit(2)
                            }
                        }
                    }
                }
            }
            .navigationTitle("key_space_news")
            .onAppear {
                viewModel.fetchArticles()
            }
        }
    }
}

#Preview {
    
}
