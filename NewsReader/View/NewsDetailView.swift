//
//  NewsDetailView.swift
//  NewsReader
//
//  Created by Fuad Salehov on 12.05.25.
//

import SwiftUI

struct NewsDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var savedManager = SavedNewsManager.shared
    
    let news: NewsViewModel
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //title
                Text(news.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                
                
                VStack(alignment: .leading) {
                    //description
                    Text(news.description ?? "")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding([.horizontal,.bottom])
                    
                    //urlToImage
                    AsyncImage(url: URL(string: news.image ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.gray.opacity(0.2))
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .clipShape(.rect(cornerRadius: 20))
                                .padding(.horizontal, 20)
                            
                        case .failure(_):
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.gray.opacity(0.2))
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                                Image(systemName: "photo.fill")
                            }
                        default:
                            EmptyView()
                            
                        }
                    }
                    
                    
                    HStack {
                        //published at
                        Text(news.relativeDateString)
                            .foregroundStyle(.gray)
                            .padding(.leading, 20)
                        
                        //source - name
                        Text(news.sourceName)
                            .padding(.leading, 30)
                    }
                    .padding(.top, 10)
                    
                    //content
                    Text(news.content ?? "")
                        .font(.headline)
                        .padding()
                    
                    Button {
                        
                    } label: {
                        Link("Read full article".uppercased(), destination: URL(string: news.url)!)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.black, in: .capsule)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if let url = URL(string: news.url) {
                        ShareLink(item: url) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        .tint(.black)
                    }
                    
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", systemImage: savedManager.isSaved(news: news) ? "bookmark.fill" : "bookmark") {
                        withAnimation(.spring) {
                            savedManager.toggleSave(news: news)
                        }
                    }
                    .tint(.black)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back", systemImage: "arrow.backward") {
                        dismiss()
                    }
                    .tint(.black)
                }
            }
        }
    }
}

#Preview {
    let sampleArticle = Article(
            source: Source(name: "BBC News"),
            title: "Swift 6 Announced with Major Improvements",
            description: "Apple has officially announced Swift 6...",
            url: "https://www.example.com",
            urlToImage: "https://cff2.earth.com/uploads/2025/05/14150624/hot-chrodingers-cat-state_quantum-effects-without-extreme-cold_1m.jpg",
            publishedAt: Date().addingTimeInterval(-3600), // 1 hour ago
            content: "Swift 6 comes with new powerful features including improved concurrency, better compile-time diagnostics, and more..."
            )

            let sampleViewModel = NewsViewModel(news: sampleArticle)

            return NewsDetailView(news: sampleViewModel)
}
