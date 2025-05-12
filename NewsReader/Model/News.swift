//
//  News.swift
//  NewsReader
//
//  Created by Fuad Salehov on 15.05.25.
//

import Foundation

struct News: Codable {
    var articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
}


struct Source: Codable {
    let name: String
}
