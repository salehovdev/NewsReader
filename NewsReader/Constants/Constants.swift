//
//  Urls.swift
//  NewsReader
//
//  Created by Fuad Salehov on 15.05.25.
//

import Foundation

struct Constants {
    
    struct urls {
        static let apiKey = "8acb660006ab483bb2b151cfa1561dfd"
        static let baseUrl = "https://newsapi.org/v2/top-headlines?"
        static let topHeadlines = "\(baseUrl)country=us&apiKey=\(apiKey)"
    }
}
