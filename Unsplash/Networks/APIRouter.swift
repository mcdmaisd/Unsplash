//
//  URLManager.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case topic(id: String)
    case search(query: String, order: String, color: String, page: Int)
    case statistics(id: String)
    
    private typealias C = APIConstants //typealias naming convention -> UpperCamelCase
    
    private var baseURL: URL {
        return URL(string: C.baseURL)!
    }
    
    private var method: HTTPMethod {
        switch self {
        case .topic, .search, .statistics:
            return .get
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .topic, .search, .statistics:
            return [C.headerKey: "\(C.headerValue)\(Unsplash.id)"]
        }
    }
    
    private var path: String {
        switch self {
        case .topic(let id):
            return makePath([C.topic, id, C.photo])
        case .search:
            return makePath([C.search, C.photo])
        case .statistics(let id):
            return makePath([C.photo, id, C.statistics])
        }
    }
    
    private var parameter: Parameters? {
        switch self {
        case .topic://연관값 미사용 시 생략 가능
            return nil
        case .search(let query, let order, let color, let page):
            var result: [String: Any] = [C.query: query, C.order: order, C.page: page]
            if !color.isEmpty { result[C.color] = color }
            return result
        case .statistics:
            return nil
        }
    }
        
    private func makePath(_ path: [String]) -> String {
        return path.compactMap { $0 }.joined(separator: C.separator)
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = header
        
        if let parameter {
            request = try URLEncoding.default.encode(request, with: parameter)
        }
        
        return request
    }
}
