//
//  APIConstants.swift
//  Unsplash
//
//  Created by ilim on 2025-01-21.
//

import Foundation

struct APIConstants {
    static let itemsPerPage = 20
    static let startPage = 1
    
    static let colorKeys = ["black", "white", "yellow", "red", "purple", "green", "blue"]
    
    static let baseURL = "https://api.unsplash.com/"
    
    static let headerKey = "Authorization"
    static let headerValue = "Client-ID "
    
    static let separator = "/"
    static let topic = "topics"
    static let photo = "photos"
    static let search = "search"
    static let statistics = "statistics"
    
    static let query = "query"
    static let page = "page"
    static let perPage = "per_page"
    static let order = "order_by"
    static let color = "color"
    static let byLatest = "latest"
    static let byRelevant = "relevant"
}
