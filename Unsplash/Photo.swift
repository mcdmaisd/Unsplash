//
//  Photo.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import Foundation

struct Topic: Codable {
    
}

struct Search: Codable {
    let total: Int
    let total_pages: Int
    let results: [Photo]
}

struct Statistics: Codable {
    
}

struct Photo: Codable {
    let id: String
    let created_at: String
    let likes: Int
    let width: Double
    let height: Double
    let user: User
    let urls: Urls
}

struct User: Codable {
    let name: String
    let profile_image: ProfileImage

}

struct Urls: Codable {
    let raw: String
    let regular: String
}

struct ProfileImage: Codable {
    let small: String
}
