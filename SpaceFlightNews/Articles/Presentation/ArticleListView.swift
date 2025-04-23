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
                if viewModel.state == .downloadingFirstPage {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    ErrorScreenView(errorMessage: error) {
                        viewModel.reload()
                    }
                } else {
                    HStack {
                        TextField("key_search", text: $viewModel.searchQuery)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .onSubmit {
                                viewModel.reload()
                            }
                        
                        if !viewModel.searchQuery.isEmpty {
                            Button(action: {
                                viewModel.clearSearchQuery()
                            }) {
                                Image(systemName: "x.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing)
                        }
                    }
                    
                    List {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(destination: ArticleDetailView(article: article)) {
                                ArticleListRow(article: article)
                                
                            }
                        }
                        
                        ProgressView()
                            .onAppear {
                                viewModel.loadMoreItems()
                            }
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .refreshable {
                        viewModel.reload()
                    }
                }
            }
            .onAppear {
                if viewModel.state == .idle {
                    viewModel.reload()
                }
            }
        }
        .navigationTitle("key_space_news")
    }
}

#Preview {
    ArticleListView(viewModel: ArticleListViewModel(articlesUseCase: DummyArticlesUseCase()))
}
