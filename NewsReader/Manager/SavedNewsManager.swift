//
//  SavedNewsManager.swift
//  NewsReader
//
//  Created by Fuad Salehov on 16.05.25.
//

import Foundation

class SavedNewsManager: ObservableObject {
    
    static let shared = SavedNewsManager()
    
    @Published var savedNews: [NewsViewModel] = []
    
    func toggleSave(news: NewsViewModel) {
        if let index = savedNews.firstIndex(where: { $0.title == news.title }) {
            savedNews.remove(at: index)
        } else {
            savedNews.append(news)
        }
    }
    
    func isSaved(news: NewsViewModel) -> Bool {
        return savedNews.contains(where: { $0.title == news.title })
    }
}
