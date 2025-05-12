//
//  ContentView.swift
//  NewsReader
//
//  Created by Fuad Salehov on 12.05.25.
//

import SwiftUI

struct NewsView: View {
    @ObservedObject var newsListViewModel: NewsListViewModel
    
    init() {
        self.newsListViewModel = NewsListViewModel()
    }
    
    @State private var selectedNews: NewsViewModel?
    @State private var selectedCategory: String? = "All"
    @State private var showDetail: Bool = false
    
    let categories = [
        "All", "Sport", "Technology", "Science", "Health", "Business", "Entertainment"
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                     ScrollView(.horizontal, showsIndicators: false) {
                        categoryView(proxy: proxy)
                     }
                }
                .navigationTitle("News")
                .onAppear {
                    Task {
                        await newsListViewModel.downloadNews(for: selectedCategory ?? "All")
                    }
                }
                .onChange(of: selectedCategory ?? "All") {
                    Task {
                        await newsListViewModel.downloadNews(for: selectedCategory ?? "All")
                    }
                }
            
                List(newsListViewModel.newsList) { news in
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
                .fullScreenCover(item: $selectedNews) { news in
                    NewsDetailView(news: news)
                }
            }
            .task {
                await newsListViewModel.downloadNews(for: selectedCategory ?? "All" )
            }
            
        }
    }
    
    //MARK: CategoriesView
    @ViewBuilder
    private func categoryView(proxy: ScrollViewProxy) -> some View {
        HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        withAnimation(.spring) {
                            selectedCategory = category
                            
                            if let index = categories.firstIndex(of: category) {
                                proxy.scrollTo(index, anchor: .center)
                            }
                        }
                    } label: {
                        Text(category)
                            .foregroundStyle(selectedCategory == category ? .white : .black.opacity(0.8))
                            .padding(10)
                            .background(selectedCategory == category ? .black : .gray.opacity(0.3))
                            .clipShape(.capsule)
                            .id(categories.firstIndex(of: category))
                    }
                }
            }
            .padding(.horizontal)
        }
}

#Preview {
    NewsView()
}
