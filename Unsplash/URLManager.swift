//
//  URLManager.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import Foundation

struct UrlConstant {
    static let perPage = 20
    static let page = 1
    static let orderByLatest = "latest"
    static let orderByRelevant = "relevant"
    static let colorKeys = ["black", "white", "yellow", "red", "purple", "green", "blue"]
}

enum UrlComponent: String {
    case baseUrl = "https://api.unsplash.com"
    case queryPrefix = "query="
    case orderPrefix = "&order_by="
    case pagePrefix = "&page="
    case perPagePrefix = "&per_page="
    case clientIDPrefix = "&client_id="
    case colorPrefix = "&color="
    case photoPrefix = "/photos"
    case searchPrefix = "/search"
    case statisticsPrefix = "/statistics"
    case topics = "/topics"
    
    enum Query {
        case topic(id: String)
        case search(query: String, order: String, color: String, page: Int)
        case statistics(id: String)
        
        var result: String {
            switch self {
            case .topic(let id):
                return "\(baseUrl.rawValue)\(topics.rawValue)/\(id)\(photoPrefix.rawValue)?\(pagePrefix.rawValue)\(UrlConstant.page)\(clientIDPrefix.rawValue)\(Unsplash.id)"
            
            case .search(let query, let order, let color, let page):
                return color.isEmpty
                ? "\(baseUrl.rawValue)\(searchPrefix.rawValue)\(photoPrefix.rawValue)?\(queryPrefix.rawValue)\(query)\(pagePrefix.rawValue)\(page)\(perPagePrefix.rawValue)\(UrlConstant.perPage)\(orderPrefix.rawValue)\(order)\(clientIDPrefix.rawValue)\(Unsplash.id)"
                : "\(baseUrl.rawValue)\(searchPrefix.rawValue)\(photoPrefix.rawValue)?\(queryPrefix.rawValue)\(query)\(pagePrefix.rawValue)\(page)\(perPagePrefix.rawValue)\(UrlConstant.perPage)\(orderPrefix.rawValue)\(order)\(colorPrefix.rawValue)\(color)\(clientIDPrefix.rawValue)\(Unsplash.id)"
            
            case .statistics(let id):
                return "\(baseUrl.rawValue)\(photoPrefix.rawValue)/\(id)\(statisticsPrefix.rawValue)?\(clientIDPrefix.rawValue)\(Unsplash.id)"
            }
        }
    }
}
