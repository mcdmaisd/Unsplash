//
//  HttpStatusCode.swift
//  Unsplash
//
//  Created by ilim on 2025-01-23.
//

import Foundation

struct ErrorMessage: Error {
    let message: String
}

enum HttpStatusCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case serviceUnavailable = 503
    
    var message: String {
        switch self {
        case .badRequest:
            return APIConstants.badRequest
        case .unauthorized:
            return APIConstants.unauthorized
        case .forbidden:
            return APIConstants.forbidden
        case .notFound:
            return APIConstants.notFound
        case .serverError:
            return APIConstants.serverError
        case .serviceUnavailable:
            return APIConstants.serviceUnavailable
        }
    }
}
