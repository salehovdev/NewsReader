//
//  SearchView.swift
//  NewsReader
//
//  Created by Fuad Salehov on 12.05.25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var showDetail = false
    @State private var selectedNews: NewsViewModel?
    
    @ObservedObject var newsListViewModel = NewsListViewModel()
    
    
    var filteredNews: [NewsViewModel] {
        if searchText.isEmpty {
            return newsListViewModel.newsList
        } else {
            return newsListViewModel.newsList.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List(filteredNews) { news in
                    Button {
                        selectedNews = news
                        showDetail.toggle()
                    } label: {
                        HStack {
                                //image
                                AsyncImage(url: URL(string: news.image ?? "")) { phase in
                                    switch phase {
                                    case .empty:
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 150, height: 100)
                                            ProgressView()
                                        }
                                        
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 100)
                                            .clipped()
                                            .cornerRadius(12)
                                            .shadow(radius: 4)
                                            .transition(.opacity.combined(with: .scale))
                                        
                                    case .failure(_):
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 150, height: 100)
                                            Image(systemName: "photo.fill")
                                                .font(.system(size: 30))
                                                .foregroundColor(.gray)
                                        }
                                    default:
                                        EmptyView()
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    //title
                                    Text(news.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    //source name&date
                                    Text("\(news.sourceName) • \(news.relativeDateString)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.leading)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .searchable(text: $searchText, prompt: "Search for news")
                .navigationTitle("Top News")
                .task {
                    await newsListViewModel.downloadNews(for: "All")
                }
                .fullScreenCover(item: $selectedNews) { news in
                    NewsDetailView(news: news)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
