//
//  NetworkManager.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func requestAPI<T: Codable>(_ router: APIRouter, _ completionHandler: @escaping (T) -> Void) {
        AF.request(router).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    dump(error)
            }
        }
    }
}
