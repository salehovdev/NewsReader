//
//  NewsViewModel.swift
//  NewsReader
//
//  Created by Fuad Salehov on 15.05.25.
//

import Foundation

class NewsListViewModel: ObservableObject {
    @Published var newsList = [NewsViewModel]()
    
    let newsManager = NewsManager()
    
    //category name map
    //"Sport", "Technology", "Science", "Politics", "Health", "Business", "Entertainment"
    private let categoryApiMap: [String: String] = [
            "All": "all",
            "Sport": "sports",
            "Technology": "technology",
            "Science": "science",
            "Health": "health",
            "Business": "business",
            "Entertainment": "entertainment"
    ]
    
    func downloadNews(for category: String) async {
        do {
            let apiCategory = categoryApiMap[category] ?? ""
            let urlString: String
            
            if apiCategory == "all" {
                urlString = Constants.urls.topHeadlines
            } else {
                urlString = "\(Constants.urls.baseUrl)category=\(category.lowercased())&apiKey=\(Constants.urls.apiKey)"
            }
            
            let articles = try await newsManager.download(urlString)
            
            DispatchQueue.main.async {
                self.newsList = articles.map(NewsViewModel.init)
            }
        } catch {
            print("error: \(error)")
        }
    }
}

struct NewsViewModel: Identifiable, Equatable {
    static func == (lhs: NewsViewModel, rhs: NewsViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    //MARK: News
    let news: Article

    
    //MARK: Variables
    let id = UUID().uuidString
    var title: String { news.title }
    var description: String? { news.description }
    var url: String { news.url }
    var image: String? { news.urlToImage }
    var date: Date { news.publishedAt }
    var content: String? { news.content }
    var sourceName: String { news.source.name }
    
    var relativeDateString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
