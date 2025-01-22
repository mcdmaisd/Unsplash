//
//  NetworkManager.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import Foundation
import Alamofire

final class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func requestAPI<T: Codable>(_ router: APIRouter, _ completionHandler: @escaping (Result<T, Error>) -> Void) {
        AF.request(router).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                dump(error)
                guard let statusCode = response.response?.statusCode else { return }
                guard let result = HttpStatusCode(rawValue: statusCode)?.message else { return }
                let errorMessage = ErrorMessage(message: result)
                completionHandler(.failure(errorMessage))
            }
        }
    }
}
