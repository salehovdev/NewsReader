//
//  NewsManager.swift
//  NewsReader
//
//  Created by Fuad Salehov on 15.05.25.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidServerResponse
}

class NewsManager {
    
    func download(_ resource: String) async throws -> [Article] {
        
        guard let url = URL(string: resource) else {
            throw NetworkError.invalidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let newsResponse = try decoder.decode(News.self, from: data)
        return newsResponse.articles
        
    }
}
