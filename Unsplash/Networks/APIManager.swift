//
//  NetworkManager.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import UIKit
import Alamofire

final class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func requestAPI<T: Codable, U: UIViewController>(_ router: APIRouter, _ view: U, _ completionHandler: @escaping (T) -> Void) {
        AF.request(router).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                dump(response)
                // response 이용하면 별도의 열거형 필요 없을 것 같은데
                guard let statusCode = response.response?.statusCode else { return }
                guard let result = HttpStatusCode(rawValue: statusCode)?.message else { return }
                view.presentAlert(message: result)
            }
        }
    }
}
