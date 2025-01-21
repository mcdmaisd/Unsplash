//
//  URLManager.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import Foundation

struct UrlConstants {
    static let perPage = 20
    static let page = 1
    static let orderByLatest = "latest"
    static let orderByRelevant = "relevant"
    static let colorKeys = ["black", "white", "yellow", "red", "purple", "green", "blue"]
}

class UrlComponent {
    static let shared = UrlComponent()

    private let scheme = "https"
    private let host = "api.unsplash.com"
    private let topicPath = "/topics"
    private let photoPath = "/photos"
    private let searchPath = "/search"
    private let statisticsPath = "/statistics"
    private let keywordQuery = "query"
    private let pageQuery = "page"
    private let perPageQuery = "per_page"
    private let orderQuery = "order_by"
    private let colorQuery = "color"

    private init() { }
    
    private func configureBaseComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        return components
    }
    
    func topic(_ id: String) -> String {
        var components = configureBaseComponents()
        components.path = topicPath + "/" + id + photoPath

        let page = URLQueryItem(name: pageQuery, value: String(UrlConstants.page))
        components.queryItems = [page]
        
        return components.url?.absoluteString ?? Constants.emptyUrl
    }
    
    func search(_ query: String, _ order: String, _ color: String, _ page: Int) -> String {
        var components = configureBaseComponents()
        components.path = searchPath + photoPath
        
        let keyword = URLQueryItem(name: keywordQuery, value: query)
        let page = URLQueryItem(name: pageQuery, value: String(page))
        let perPage = URLQueryItem(name: perPageQuery, value: String(UrlConstants.perPage))
        let order = URLQueryItem(name: orderQuery, value: order)
        let colorItem = URLQueryItem(name: colorQuery, value: color)
        
        var queryList: [URLQueryItem] = [keyword, page, perPage, order]
        
        if !color.isEmpty {
            queryList.append(colorItem)
        }
        
        components.queryItems = queryList
        
        return components.url?.absoluteString ?? Constants.emptyUrl
    }
    
    func statistics(_ id: String) -> String {
        var components = configureBaseComponents()
        components.path = photoPath + "/" + id + statisticsPath
        
        return components.url?.absoluteString ?? Constants.emptyUrl
    }
}
