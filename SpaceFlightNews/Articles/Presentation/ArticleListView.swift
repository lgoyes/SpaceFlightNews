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
                .accessibilityIdentifier("ArticleRowTitle_\(article.id)")
            Text(PublicationDateFormatter(article: article).getPublicationDate())
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
                    buildLoadingScreen()
                } else if let error = viewModel.errorMessage {
                    buildErrorScreen(error: error)
                } else {
                    buildSearchBar()
                    buildArticlesList()
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
    
    @ViewBuilder
    private func buildLoadingScreen() -> some View {
        Spacer()
        ProgressView()
        Spacer()
    }
    
    private func buildErrorScreen(error: String) -> some View {
        ErrorScreenView(errorMessage: error) {
            viewModel.reload()
        }
    }
    
    private func buildSearchBar() -> some View {
        SearchBar(searchQuery: $viewModel.searchQuery) {
            viewModel.reload()
        }
    }
    
    private func buildArticlesList() -> some View {
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

struct SearchBar: View {
    @Binding var searchQuery: String
    var onSubmit: () -> Void
    
    var body: some View {
        HStack {
            TextField("key_search", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit(onSubmit)
            
            if !searchQuery.isEmpty {
                Button(action: {
                    searchQuery = ""
                    onSubmit()
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }
        }
    }
}

#Preview {
    ArticleListView(viewModel: ArticleListViewModel(articlesUseCase: DummyArticlesUseCase()))
}
