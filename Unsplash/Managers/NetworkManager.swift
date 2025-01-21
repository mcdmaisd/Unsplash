//
//  NetworkManager.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    let header: HTTPHeaders = [
        "Authorization": "Client-ID \(Unsplash.id)"
    ]
    
    func requestAPI<T: Codable>(_ url: String, _ completionHandler: @escaping (T) -> Void) {
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    dump(error)
            }
        }
    }
}
